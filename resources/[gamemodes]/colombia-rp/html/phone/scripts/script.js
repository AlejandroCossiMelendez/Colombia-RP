"use strict";

const get = (element) => { return document.querySelector(element) };
const getAll = (element) => { return document.querySelectorAll(element) };

// Variables para el gesto de arrastre
let isDragging = false;
let startY = 0;
let currentY = 0;
let dragThreshold = 80; // Píxeles que debe arrastrar para cerrar (aumentado para mejor UX)
let isClosing = false; // Flag para evitar múltiples cierres

const config = {
    battery: {
        getValue: () => get('.battery .bar').style.width,
        setValue: (value) => (get('.battery .bar').style.width = `${value}%`),
    },
    screenTimer: 30000,
}

onload = () => {
    config.battery.setValue(48);
    get('.battery .bar').style.width = `${config.battery.currentValue}%`;
    // Abrir directamente en el home (no en la pantalla de bloqueo)
    const lock = get('.lock-screen');
    const unlock = get('.unlock-screen');
    if (lock && unlock) {
        lock.style.display = 'none';
        unlock.style.display = 'flex';
    }
    // Inicializar isInHomeScreen
    isInHomeScreen = true;
    
    // Habilitar gesto de deslizar hacia abajo para cerrar el teléfono
    setupDragToClose();
    
    // Cargar fondo guardado
    const savedBackground = localStorage.getItem('phoneBackground') || '2.jpg';
    changeBackground(savedBackground);
}

// Función para configurar el gesto de arrastre hacia abajo para cerrar
function setupDragToClose() {
    const iphone = get('.iphone');
    if (!iphone) return;
    
    // Área superior del teléfono donde se puede arrastrar (solo notch y área pequeña)
    // No cubrir toda la parte superior para no interferir con botones
    const dragArea = document.createElement('div');
    dragArea.style.position = 'absolute';
    dragArea.style.top = '0';
    dragArea.style.left = '50%';
    dragArea.style.transform = 'translateX(-50%)';
    dragArea.style.width = '120px'; // Solo el área del notch
    dragArea.style.height = '60px';
    dragArea.style.zIndex = '50'; // Menor que botones y elementos interactivos
    dragArea.style.cursor = 'grab';
    dragArea.style.userSelect = 'none';
    dragArea.style.pointerEvents = 'auto';
    iphone.appendChild(dragArea);
    
    // Evento cuando se presiona el mouse/touch - solo si no es un botón
    dragArea.addEventListener('mousedown', function(e) {
        // Si el clic es en un botón o elemento interactivo, no iniciar arrastre
        const target = e.target;
        if (target && (target.tagName === 'BUTTON' || target.closest('button') || target.closest('.add-contact-btn'))) {
            return;
        }
        handleDragStart(e);
    });
    dragArea.addEventListener('touchstart', function(e) {
        const target = e.target;
        if (target && (target.tagName === 'BUTTON' || target.closest('button') || target.closest('.add-contact-btn'))) {
            return;
        }
        handleDragStart(e);
    }, { passive: false });
    
    // Evento cuando se mueve el mouse/touch
    document.addEventListener('mousemove', handleDragMove);
    document.addEventListener('touchmove', handleDragMove, { passive: false });
    
    // Evento cuando se suelta el mouse/touch
    document.addEventListener('mouseup', handleDragEnd);
    document.addEventListener('touchend', handleDragEnd);
}

function handleDragStart(e) {
    isDragging = true;
    const clientY = e.touches ? e.touches[0].clientY : e.clientY;
    startY = clientY;
    currentY = clientY;
    
    // Prevenir scroll mientras se arrastra
    if (e.touches) {
        e.preventDefault();
    }
}

function handleDragMove(e) {
    if (!isDragging || isClosing) return;
    
    const clientY = e.touches ? e.touches[0].clientY : e.clientY;
    currentY = clientY;
    
    const deltaY = currentY - startY;
    
    // Solo permitir arrastre hacia abajo
    if (deltaY > 0) {
        const iphone = get('.iphone');
        if (iphone) {
            // Mover el teléfono visualmente mientras se arrastra
            const maxMove = 300; // Máximo movimiento en píxeles (aumentado)
            const moveAmount = Math.min(deltaY, maxMove);
            iphone.style.transform = `translateY(${moveAmount}px)`;
            iphone.style.transition = 'none';
            
            // Cambiar opacidad mientras se arrastra
            const opacity = Math.max(0.3, 1 - (moveAmount / maxMove) * 0.7);
            iphone.style.opacity = opacity;
            
            // Si se arrastra más del umbral, cambiar el color para indicar que se cerrará
            if (deltaY > dragThreshold) {
                iphone.style.filter = 'brightness(0.7)';
            } else {
                iphone.style.filter = 'brightness(1)';
            }
        }
        
        // Prevenir scroll
        if (e.touches) {
            e.preventDefault();
        }
    }
}

function handleDragEnd(e) {
    if (!isDragging || isClosing) return;
    
    const deltaY = currentY - startY;
    const iphone = get('.iphone');
    
    // Si se arrastró lo suficiente, cerrar el teléfono
    if (deltaY > dragThreshold && iphone) {
        isClosing = true;
        isDragging = false;
        
        // Animación de cierre suave
        iphone.style.transition = 'transform 0.4s ease-out, opacity 0.4s ease-out, filter 0.4s ease-out';
        iphone.style.transform = 'translateY(400px)';
        iphone.style.opacity = '0';
        iphone.style.filter = 'brightness(0.5)';
        
        // Cerrar el teléfono después de la animación
        setTimeout(function() {
            // Guardar contactos solo si estamos en la app de contactos
            const contactsApp = get('[data-app-id="6"]');
            if (contactsApp && contactsApp.style.display !== 'none') {
                saveContactsToMTA();
            }
            
            // Cerrar el teléfono
            if (window.mta && window.mta.triggerEvent) {
                window.mta.triggerEvent('closePhoneFromBrowser');
            }
            
            // NO resetear estilos aquí - el navegador se destruirá completamente
            // No resetear isClosing aquí para evitar que vuelva a aparecer
            isDragging = false;
            startY = 0;
            currentY = 0;
        }, 400);
    } else if (iphone) {
        // Volver a la posición original con animación
        isDragging = false;
        iphone.style.transition = 'transform 0.3s ease-out, opacity 0.3s ease-out, filter 0.3s ease-out';
        iphone.style.transform = 'translateY(0)';
        iphone.style.opacity = '1';
        iphone.style.filter = 'brightness(1)';
    }
    
    startY = 0;
    currentY = 0;
}

// Función para guardar contactos en MTA
function saveContactsToMTA() {
    // Solo guardar si MTA está disponible y contacts está definido
    if (!window.mta || !window.mta.triggerEvent) {
        console.warn('[saveContactsToMTA] MTA no está disponible');
        return;
    }
    
    if (typeof contacts === 'undefined') {
        console.warn('[saveContactsToMTA] contacts no está definido');
        return;
    }
    
    try {
        const contactsToSave = contacts || [];
        const jsonString = JSON.stringify(contactsToSave);
        console.log('[saveContactsToMTA] Guardando', contactsToSave.length, 'contactos');
        console.log('[saveContactsToMTA] JSON:', jsonString);
        window.mta.triggerEvent('saveContacts', jsonString);
        console.log('[saveContactsToMTA] Evento enviado correctamente');
    } catch (e) {
        console.error('[saveContactsToMTA] Error al guardar contactos:', e);
    }
}

const [lock, unlock] = [get('.lock-screen'), get('.unlock-screen')];
const interfaces = get('.apps-interfaces');
const apps = getAll('.app');
const appsInterfaces = getAll('.app-interface');

const homeButtom = get('.home-button');

function openApp(appId) {
    unlock.style.display = 'none';
    interfaces.style.display = 'block';
    appsInterfaces.item(appId).style.display = 'block';
    isInHomeScreen = false;
    
    // Si es la app de contactos (appId 6), cargar contactos
    if (appId === 6) {
        loadContacts();
    }
    
    // Si es la app de galería (appId 7), cargar imágenes
    if (appId === 7) {
        loadGallery();
    }
    
    // Si es la app de teléfono (appId 5), inicializar marcador
    if (appId === 5) {
        initPhoneApp();
        // Solicitar estado de llamada activa
        if (window.mta && window.mta.triggerEvent) {
            window.mta.triggerEvent('phone:requestCallStatus');
        }
    }
    
    // Si es la app de Spotify (appId 8), inicializar Spotify
    if (appId === 8) {
        initSpotifyApp();
    }
    
    // Si es la app de navegador (appId 9), inicializar navegador
    if (appId === 9) {
        initBrowserApp();
    }
}

let isInHomeScreen = true; // Variable para rastrear si estamos en el home

function returnToHomePage() {
    // Verificar si realmente estamos en el home (unlock visible y no hay apps abiertas)
    const unlockVisible = unlock && unlock.style.display !== 'none' && unlock.style.display !== '';
    const interfacesVisible = interfaces && (interfaces.style.display === 'block' || interfaces.style.display === 'flex');
    
    // Si ya está en el home (unlock visible y interfaces ocultas), cerrar el teléfono
    if (unlockVisible && !interfacesVisible) {
        // Cerrar el teléfono enviando evento a MTA (no guardar contactos aquí para evitar bugs)
        if (window.mta && window.mta.triggerEvent) {
            window.mta.triggerEvent('closePhoneFromBrowser');
        }
        return;
    }
    // Si está en una app, volver al home
    if (lock) lock.style.display = 'none';
    if (unlock) unlock.style.display = 'flex';
    if (interfaces) interfaces.style.display = 'none';
    if (appsInterfaces) {
        appsInterfaces.forEach(e => {
            if (e) e.style.display = 'none';
        });
    }
    // Ocultar formulario de agregar contacto si está visible
    const addForm = get('#addContactForm');
    if (addForm) addForm.style.display = 'none';
    isInHomeScreen = true;
}

let inactivityTimeout;

function resetInactivityTimer() {
    clearTimeout(inactivityTimeout);
    inactivityTimeout = setTimeout(function () {
        appsInterfaces.forEach(e => e.style.display = 'none');
        interfaces.style.display = 'none';
        unlock.style.display = 'none';
        lock.style.display = 'block';
    }, config.screenTimer);
}

document.addEventListener("mousemove", resetInactivityTimer);
document.addEventListener("keydown", resetInactivityTimer);

function updateTime() {
    get('.digital-clock').textContent = new Intl.DateTimeFormat('en-US', { hour: 'numeric', minute: 'numeric' }).format(new Date());
    get('.the-date').textContent = new Intl.DateTimeFormat('en-US', { month: 'long', day: '2-digit', weekday: 'long' }).format(new Date());
    get('.time').textContent = new Intl.DateTimeFormat('en-US', { hour: 'numeric', minute: 'numeric' }).format(new Date()).replace(/(PM|AM)/i, '');
}

apps.forEach((app, key) => app.onclick = (e) => openApp(key));
homeButtom.onclick = (e) => returnToHomePage();

/* Gallery App */
let currentBackground = localStorage.getItem('phoneBackground') || '2.jpg'; // Fondo por defecto

// Función para cargar la galería
function loadGallery() {
    const galleryGrid = get('#galleryGrid');
    if (!galleryGrid) return;
    
    galleryGrid.innerHTML = '';
    
    // Cargar las 6 imágenes de fondo disponibles
    for (let i = 1; i <= 6; i++) {
        const galleryItem = document.createElement('div');
        galleryItem.className = 'gallery-item';
        if (currentBackground === `${i}.jpg`) {
            galleryItem.classList.add('selected');
        }
        
        const img = document.createElement('img');
        img.src = `./phone/styles/backgrounds/${i}.jpg`;
        img.alt = `Fondo ${i}`;
        
        const overlay = document.createElement('div');
        overlay.className = 'gallery-item-overlay';
        
        const check = document.createElement('div');
        check.className = 'gallery-item-check';
        check.textContent = '✓';
        overlay.appendChild(check);
        
        galleryItem.appendChild(img);
        galleryItem.appendChild(overlay);
        
        // Agregar evento click para cambiar el fondo
        galleryItem.addEventListener('click', function() {
            changeBackground(`${i}.jpg`);
            // Remover selección de todos los items
            document.querySelectorAll('.gallery-item').forEach(item => {
                item.classList.remove('selected');
            });
            // Agregar selección al item clickeado
            galleryItem.classList.add('selected');
        });
        
        galleryGrid.appendChild(galleryItem);
    }
}

// Función para cambiar el fondo de pantalla
function changeBackground(filename) {
    currentBackground = filename;
    localStorage.setItem('phoneBackground', filename);
    
    // Cambiar el fondo del unlock-screen
    const unlockScreen = get('.unlock-screen');
    if (unlockScreen) {
        unlockScreen.style.backgroundImage = `url('./phone/styles/backgrounds/${filename}')`;
        unlockScreen.style.backgroundPosition = 'center';
        unlockScreen.style.backgroundSize = 'cover';
    }
    
    // Notificar a MTA que el fondo cambió (opcional, para guardar en servidor)
    if (window.mta && window.mta.triggerEvent) {
        window.mta.triggerEvent('changePhoneBackground', filename);
    }
}


/* Contacts App */
let contacts = [];
let myPhoneNumber = '';

// Función para recibir el número de teléfono desde MTA
function setMyPhoneNumber(number) {
    myPhoneNumber = number;
    // No cargar contactos aquí, esperar a que lleguen del servidor
    // Los contactos se cargarán cuando se reciba loadContactsFromServer
}

// Función para cargar contactos desde el servidor
function loadContactsFromServer(contactsJson) {
    try {
        if (contactsJson && contactsJson !== '[]' && contactsJson !== '') {
            const parsedContacts = JSON.parse(contactsJson);
            if (Array.isArray(parsedContacts)) {
                contacts = parsedContacts;
                console.log('Contactos cargados desde el servidor:', contacts.length);
                loadContacts();
            }
        } else {
            contacts = [];
            console.log('No hay contactos guardados, iniciando con lista vacía');
            loadContacts();
        }
    } catch (e) {
        console.error('Error al cargar contactos desde el servidor:', e);
        contacts = [];
        loadContacts();
    }
}

// Función para configurar swipe to delete
function setupSwipeToDelete(contactItem, index, contactNumber) {
    let startX = 0;
    let currentX = 0;
    let isDragging = false;
    let hasDeleted = false;
    
    contactItem.addEventListener('touchstart', function(e) {
        if (hasDeleted) return;
        startX = e.touches[0].clientX;
        isDragging = true;
        contactItem.style.transition = 'none';
    });
    
    contactItem.addEventListener('touchmove', function(e) {
        if (!isDragging || hasDeleted) return;
        currentX = e.touches[0].clientX - startX;
        
        // Solo permitir deslizar hacia la izquierda
        if (currentX < 0) {
            const translateX = Math.max(currentX, -100); // Máximo 100px hacia la izquierda
            contactItem.querySelector('.contact-content').style.transform = `translateX(${translateX}px)`;
            contactItem.querySelector('.delete-area').style.opacity = Math.min(Math.abs(translateX) / 100, 1);
        }
    });
    
    contactItem.addEventListener('touchend', function(e) {
        if (!isDragging || hasDeleted) return;
        isDragging = false;
        
        const translateX = currentX;
        contactItem.style.transition = 'transform 0.3s ease';
        
        // Si se deslizó más de 50px hacia la izquierda, eliminar
        if (translateX < -50) {
            hasDeleted = true;
            contactItem.style.transform = 'translateX(-100%)';
            contactItem.style.opacity = '0';
            
            setTimeout(() => {
                // Usar null como índice y el número como identificador principal
                deleteContact(null, contactNumber, true); // true = skipConfirm
            }, 300);
        } else {
            // Volver a la posición original
            contactItem.querySelector('.contact-content').style.transform = 'translateX(0)';
            contactItem.querySelector('.delete-area').style.opacity = '0';
        }
    });
    
    // También soportar mouse para pruebas en desktop
    contactItem.addEventListener('mousedown', function(e) {
        if (hasDeleted) return;
        startX = e.clientX;
        isDragging = true;
        contactItem.style.transition = 'none';
        e.preventDefault();
    });
    
    contactItem.addEventListener('mousemove', function(e) {
        if (!isDragging || hasDeleted) return;
        currentX = e.clientX - startX;
        
        if (currentX < 0) {
            const translateX = Math.max(currentX, -100);
            contactItem.querySelector('.contact-content').style.transform = `translateX(${translateX}px)`;
            contactItem.querySelector('.delete-area').style.opacity = Math.min(Math.abs(translateX) / 100, 1);
        }
    });
    
    contactItem.addEventListener('mouseup', function(e) {
        if (!isDragging || hasDeleted) return;
        isDragging = false;
        
        const translateX = currentX;
        contactItem.style.transition = 'transform 0.3s ease';
        
        if (translateX < -50) {
            hasDeleted = true;
            contactItem.style.transform = 'translateX(-100%)';
            contactItem.style.opacity = '0';
            
            setTimeout(() => {
                // Usar null como índice y el número como identificador principal
                deleteContact(null, contactNumber, true); // true = skipConfirm
            }, 300);
        } else {
            contactItem.querySelector('.contact-content').style.transform = 'translateX(0)';
            contactItem.querySelector('.delete-area').style.opacity = '0';
        }
    });
    
    contactItem.addEventListener('mouseleave', function(e) {
        if (!isDragging || hasDeleted) return;
        isDragging = false;
        contactItem.style.transition = 'transform 0.3s ease';
        contactItem.querySelector('.contact-content').style.transform = 'translateX(0)';
        contactItem.querySelector('.delete-area').style.opacity = '0';
    });
}

// Función para cargar contactos
function loadContacts() {
    const contactsList = get('#contactsList');
    if (!contactsList) return;
    
    contactsList.innerHTML = '';
    
    // Agregar "Mi contacto" como primer contacto
    if (myPhoneNumber) {
        const myContact = document.createElement('div');
        myContact.className = 'contact-item';
        myContact.innerHTML = `
            <div class="contact-avatar">Yo</div>
            <div class="contact-info">
                <div class="contact-name">Mi contacto</div>
                <div class="contact-number">${myPhoneNumber}</div>
            </div>
        `;
        contactsList.appendChild(myContact);
    }
    
    // Agregar otros contactos
    contacts.forEach((contact, index) => {
        const contactItem = document.createElement('div');
        contactItem.className = 'contact-item';
        contactItem.setAttribute('data-contact-index', index);
        contactItem.setAttribute('data-contact-number', contact.number);
        
        // Contenedor interno para el swipe
        const contactContent = document.createElement('div');
        contactContent.className = 'contact-content';
        
        // Área de eliminación (se muestra al deslizar)
        const deleteArea = document.createElement('div');
        deleteArea.className = 'delete-area';
        deleteArea.innerHTML = '<span>Eliminar</span>';
        
        const avatar = document.createElement('div');
        avatar.className = 'contact-avatar';
        avatar.textContent = contact.name.charAt(0).toUpperCase();
        
        const info = document.createElement('div');
        info.className = 'contact-info';
        
        const name = document.createElement('div');
        name.className = 'contact-name';
        name.textContent = contact.name;
        
        const number = document.createElement('div');
        number.className = 'contact-number';
        number.textContent = contact.number;
        
        info.appendChild(name);
        info.appendChild(number);
        
        contactContent.appendChild(avatar);
        contactContent.appendChild(info);
        
        contactItem.appendChild(deleteArea);
        contactItem.appendChild(contactContent);
        
        // Agregar funcionalidad de swipe
        setupSwipeToDelete(contactItem, index, contact.number);
        
        contactsList.appendChild(contactItem);
    });
}

// Función para mostrar formulario de agregar contacto
function showAddContactForm(e) {
    if (e) {
        e.stopPropagation();
        e.preventDefault();
    }
    const form = get('#addContactForm');
    if (form) {
        form.style.display = 'block';
        const nameInput = get('#contactName');
        const numberInput = get('#contactNumber');
        if (nameInput) nameInput.value = '';
        if (numberInput) numberInput.value = '';
    }
}

// Exponer función globalmente
window.showAddContactForm = showAddContactForm;

// Función para ocultar formulario
function hideAddContactForm() {
    const form = get('#addContactForm');
    if (form) {
        form.style.display = 'none';
    }
}

// Función para agregar contacto
function addContact() {
    const nameInput = get('#contactName');
    const numberInput = get('#contactNumber');
    
    if (!nameInput || !numberInput) {
        console.error('No se encontraron los campos del formulario');
        return;
    }
    
    const name = nameInput.value.trim();
    const number = numberInput.value.trim();
    
    if (!name || !number) {
        alert('Por favor completa todos los campos');
        return;
    }
    
    // Validar formato del número (XXX-XXXXXXX)
    const numberRegex = /^\d{3}-\d{7}$/;
    if (!numberRegex.test(number)) {
        alert('El número debe tener el formato XXX-XXXXXXX');
        return;
    }
    
    // Verificar si el contacto ya existe
    const exists = contacts.some(c => c.number === number);
    if (exists) {
        alert('Este número ya está en tus contactos');
        return;
    }
    
    // Agregar el contacto
    contacts.push({ name, number });
    console.log('Contacto agregado:', { name, number });
    console.log('Total de contactos:', contacts.length);
    
    // Recargar la lista de contactos
    loadContacts();
    
    // Ocultar el formulario
    hideAddContactForm();
    
    // Guardar en MTA inmediatamente después de agregar
    if (window.mta && window.mta.triggerEvent) {
        try {
            const jsonString = JSON.stringify(contacts);
            console.log('Guardando contactos después de agregar:', contacts.length, 'contactos');
            console.log('JSON a enviar:', jsonString);
            window.mta.triggerEvent('saveContacts', jsonString);
            console.log('Evento saveContacts enviado correctamente');
        } catch (e) {
            console.error('Error al guardar contactos:', e);
            alert('Error al guardar contactos. Por favor intenta de nuevo.');
        }
    } else {
        console.warn('MTA no está disponible, los contactos se guardarán solo en memoria');
        alert('Error: No se pudo conectar con el servidor para guardar contactos.');
    }
}

// Función para eliminar contacto
function deleteContact(index, contactNumber, skipConfirm) {
    console.log('deleteContact llamado con índice:', index, 'número:', contactNumber);
    console.log('Contactos antes de eliminar:', contacts);
    
    let contactToDelete = null;
    let deleteIndex = -1;
    
    // Intentar usar el índice primero
    if (index !== undefined && index !== null && !isNaN(index) && index >= 0 && index < contacts.length) {
        contactToDelete = contacts[index];
        deleteIndex = index;
    }
    
    // Si el índice no funciona o el contacto no coincide, buscar por número
    if (!contactToDelete && contactNumber) {
        deleteIndex = contacts.findIndex(c => c.number === contactNumber);
        if (deleteIndex !== -1) {
            contactToDelete = contacts[deleteIndex];
        }
    }
    
    // Si aún no se encontró, mostrar error
    if (!contactToDelete || deleteIndex === -1) {
        console.error('No se pudo encontrar el contacto a eliminar. Índice:', index, 'Número:', contactNumber);
        alert('Error: No se pudo encontrar el contacto a eliminar.');
        return;
    }
    
    // Si skipConfirm es true (llamado desde swipe), eliminar directamente
    // Si es false o undefined, pedir confirmación
    const shouldDelete = skipConfirm || confirm('¿Eliminar el contacto "' + contactToDelete.name + '"?');
    
    if (shouldDelete) {
        // Eliminar del array
        contacts.splice(deleteIndex, 1);
        console.log('Contacto eliminado. Contactos restantes:', contacts);
        
        // Guardar en MTA ANTES de recargar la lista
        if (window.mta && window.mta.triggerEvent) {
            try {
                const jsonString = JSON.stringify(contacts);
                console.log('Guardando contactos después de eliminar:', contacts.length, 'contactos');
                console.log('JSON a enviar:', jsonString);
                window.mta.triggerEvent('saveContacts', jsonString);
                console.log('Evento saveContacts enviado correctamente después de eliminar');
                
                // Recargar la lista después de un pequeño delay para asegurar que el guardado se procese
                setTimeout(() => {
                    loadContacts();
                }, 100);
            } catch (e) {
                console.error('Error al guardar contactos:', e);
                alert('Error al guardar contactos. Por favor intenta de nuevo.');
                // Recargar de todas formas para reflejar el cambio visual
                loadContacts();
            }
        } else {
            console.error('MTA no está disponible para guardar contactos');
            alert('Error: No se pudo conectar con el servidor para guardar contactos.');
            // Recargar de todas formas para reflejar el cambio visual
            loadContacts();
        }
    }
}

// Exponer funciones para MTA
window.setMyPhoneNumber = setMyPhoneNumber;
window.openApp = openApp;

// ==================== SISTEMA DE LLAMADAS ====================

let currentCall = null;
let callTimer = null;
let callStartTime = null;
let isSpeakerOn = false;

// Inicializar app de teléfono
function initPhoneApp() {
    const phoneInput = get('#phoneNumberInput');
    const keypadButtons = getAll('.keypad-btn');
    const callButton = get('#callButton');
    const deleteButton = get('#deleteButton');
    const searchResults = get('#searchResults');
    
    if (!phoneInput) return;
    
    // Limpiar input
    phoneInput.value = '';
    phoneInput.addEventListener('input', handlePhoneInput);
    
    // Configurar teclado numérico
    keypadButtons.forEach(btn => {
        btn.addEventListener('click', function() {
            const number = this.getAttribute('data-number');
            if (phoneInput) {
                phoneInput.value += number;
                handlePhoneInput();
            }
        });
    });
    
    // Botón de llamar
    if (callButton) {
        callButton.addEventListener('click', function() {
            const number = phoneInput ? phoneInput.value.trim() : '';
            if (number) {
                makeCall(number);
            }
        });
    }
    
    // Botón de borrar
    if (deleteButton) {
        deleteButton.addEventListener('click', function() {
            if (phoneInput) {
                phoneInput.value = phoneInput.value.slice(0, -1);
                handlePhoneInput();
            }
        });
    }
    
    // Botones de llamada activa
    const speakerButton = get('#speakerButton');
    const hangupButton = get('#hangupButton');
    
    if (speakerButton) {
        speakerButton.addEventListener('click', function() {
            toggleSpeaker();
        });
    }
    
    // Configurar botón de colgar
    if (hangupButton) {
        hangupButton.addEventListener('click', function() {
            hangupCall();
        });
    }
    
    if (hangupButton) {
        hangupButton.addEventListener('click', function() {
            hangupCall();
        });
    }
}

// Manejar input del teléfono (búsqueda)
function handlePhoneInput() {
    const phoneInput = get('#phoneNumberInput');
    const searchResults = get('#searchResults');
    
    if (!phoneInput || !searchResults) return;
    
    const query = phoneInput.value.trim();
    
    if (query.length === 0) {
        searchResults.style.display = 'none';
        return;
    }
    
    // Buscar en contactos
    const results = searchContacts(query);
    
    if (results.length > 0) {
        searchResults.innerHTML = '';
        results.forEach(contact => {
            const item = document.createElement('div');
            item.className = 'search-result-item';
            item.innerHTML = `
                <div class="search-result-name">${contact.name}</div>
                <div class="search-result-number">${contact.number}</div>
            `;
            item.addEventListener('click', function() {
                if (phoneInput) {
                    phoneInput.value = contact.number;
                    searchResults.style.display = 'none';
                }
            });
            searchResults.appendChild(item);
        });
        searchResults.style.display = 'block';
    } else {
        searchResults.style.display = 'none';
    }
}

// Buscar en contactos
function searchContacts(query) {
    if (!contacts || !Array.isArray(contacts)) return [];
    
    const lowerQuery = query.toLowerCase();
    return contacts.filter(contact => {
        return contact.name.toLowerCase().includes(lowerQuery) ||
               contact.number.includes(query);
    });
}

// Realizar llamada
function makeCall(number) {
    if (currentCall) {
        return; // Ya hay una llamada activa
    }
    
    // Limpiar formato del número (quitar guiones)
    const cleanNumber = number.replace(/-/g, '');
    
    if (window.mta && window.mta.triggerEvent) {
        window.mta.triggerEvent('phone:makeCall', cleanNumber);
        // Mostrar estado de "Llamando..." solo si la llamada se inicia correctamente
        // El servidor confirmará con onCallStarted o onCallFailed
    }
}

// Mostrar estado de llamada
function showCallStatus(status, number) {
    const callStatus = get('#callStatus');
    const callInfo = get('#callInfo');
    const callTimer = get('#callTimer');
    const phoneContent = get('.phone-content');
    
    if (callStatus && callInfo && callTimer) {
        callStatus.style.display = 'block';
        callInfo.textContent = status + (number ? ' - ' + formatPhoneNumber(number) : '');
        callTimer.textContent = '00:00';
        
        // Ocultar controles de marcado usando clase CSS para mantener el layout
        if (phoneContent) {
            const dialerSection = phoneContent.querySelector('.dialer-section');
            const keypad = phoneContent.querySelector('.keypad');
            const callControls = phoneContent.querySelector('.call-controls');
            
            if (dialerSection) dialerSection.classList.add('hidden');
            if (keypad) keypad.classList.add('hidden');
            if (callControls) callControls.classList.add('hidden');
        }
    }
}

// Ocultar estado de llamada
function hideCallStatus() {
    const callStatus = get('#callStatus');
    const phoneContent = get('.phone-content');
    
    if (callStatus) {
        callStatus.style.display = 'none';
    }
    
    // Restaurar controles de marcado removiendo la clase hidden
    if (phoneContent) {
        const dialerSection = phoneContent.querySelector('.dialer-section');
        const keypad = phoneContent.querySelector('.keypad');
        const callControls = phoneContent.querySelector('.call-controls');
        
        if (dialerSection) {
            dialerSection.classList.remove('hidden');
        }
        if (keypad) {
            keypad.classList.remove('hidden');
            // Forzar reflow para restaurar el grid correctamente
            void keypad.offsetHeight;
        }
        if (callControls) {
            callControls.classList.remove('hidden');
        }
    }
}

// Formatear número de teléfono
function formatPhoneNumber(number) {
    if (number.length === 10) {
        return number.slice(0, 3) + '-' + number.slice(3);
    }
    return number;
}

// Iniciar temporizador de llamada
function startCallTimer() {
    callStartTime = Date.now();
    if (callTimer) {
        clearInterval(callTimer);
    }
    callTimer = setInterval(function() {
        if (callStartTime) {
            const elapsed = Math.floor((Date.now() - callStartTime) / 1000);
            const minutes = Math.floor(elapsed / 60);
            const seconds = elapsed % 60;
            const callTimerElement = get('#callTimer');
            if (callTimerElement) {
                callTimerElement.textContent = 
                    String(minutes).padStart(2, '0') + ':' + 
                    String(seconds).padStart(2, '0');
            }
        }
    }, 1000);
}

// Detener temporizador de llamada
function stopCallTimer() {
    if (callTimer) {
        clearInterval(callTimer);
        callTimer = null;
    }
    callStartTime = null;
}

// Activar/desactivar altavoz
function toggleSpeaker() {
    isSpeakerOn = !isSpeakerOn;
    const speakerButton = get('#speakerButton');
    
    if (speakerButton) {
        if (isSpeakerOn) {
            speakerButton.classList.add('active');
        } else {
            speakerButton.classList.remove('active');
        }
    }
    
    if (window.mta && window.mta.triggerEvent) {
        window.mta.triggerEvent('phone:toggleSpeaker', isSpeakerOn);
    }
}

// Colgar llamada
function hangupCall() {
    if (window.mta && window.mta.triggerEvent) {
        window.mta.triggerEvent('phone:hangup');
    }
    endCall();
}

// Exponer función globalmente para que MTA pueda llamarla
window.hangupCall = hangupCall;

// Terminar llamada
function endCall() {
    currentCall = null;
    stopCallTimer();
    hideCallStatus();
    isSpeakerOn = false;
    
    const speakerButton = get('#speakerButton');
    if (speakerButton) {
        speakerButton.classList.remove('active');
    }
}

// Eventos desde MTA
window.onCallStarted = function(partnerName, partnerNumber) {
    if (!partnerName || !partnerNumber) {
        return;
    }
    
    currentCall = {
        partner: partnerName,
        number: partnerNumber
    };
    
    showCallStatus('En llamada', partnerNumber);
    startCallTimer();
}

// Mostrar llamada activa cuando se abre el teléfono
window.showActiveCall = function(partnerName, partnerNumber, duration, speakerEnabled) {
    if (!partnerName || !partnerNumber) {
        return;
    }
    
    currentCall = {
        partner: partnerName,
        number: partnerNumber
    };
    
    // Mostrar estado de llamada
    showCallStatus('En llamada', partnerNumber);
    
    // Actualizar timer si hay duración
    if (duration && duration > 0) {
        const minutes = Math.floor(duration / 60);
        const seconds = duration % 60;
        const timerElement = get('#callTimer');
        if (timerElement) {
            timerElement.textContent = `${String(minutes).padStart(2, '0')}:${String(seconds).padStart(2, '0')}`;
        }
        // Reiniciar timer desde la duración actual
        callStartTime = Date.now() - (duration * 1000);
        startCallTimer();
    }
    
    // Actualizar estado del altavoz
    if (speakerEnabled !== undefined) {
        isSpeakerOn = speakerEnabled;
        const speakerButton = get('#speakerButton');
        if (speakerButton) {
            if (isSpeakerOn) {
                speakerButton.classList.add('active');
            } else {
                speakerButton.classList.remove('active');
            }
        }
    }
}

window.onCallAnswered = function() {
    const callInfo = get('#callInfo');
    if (callInfo && currentCall) {
        callInfo.textContent = 'En llamada - ' + formatPhoneNumber(currentCall.receiver || currentCall.caller);
    }
    startCallTimer();
};

window.onCallEnded = function() {
    endCall();
    // Restaurar controles inmediatamente
    hideCallStatus();
    
    // Limpiar estado de llamada
    currentCall = null;
    
    // Asegurar que el keypad se restaure correctamente y mantenga el grid 3x4
    setTimeout(function() {
        const keypad = get('.keypad');
        if (keypad) {
            // Forzar que el grid se recalcule correctamente
            keypad.style.display = 'none';
            void keypad.offsetHeight; // Forzar reflow
            keypad.style.display = 'grid';
            void keypad.offsetHeight; // Forzar otro reflow para asegurar
        }
    }, 10);
};

window.onIncomingCall = function(callerNumber, callerName) {
    // Esto se manejará en el cliente Lua para mostrar notificación
    if (window.mta && window.mta.triggerEvent) {
        window.mta.triggerEvent('phone:incomingCall', callerNumber, callerName);
    }
};
window.loadContacts = loadContacts;
window.showAddContactForm = showAddContactForm;
window.hideAddContactForm = hideAddContactForm;
window.addContact = addContact;

/* Calculator App */

const resultBoard = get('.result-board');
const operations = getAll('.operations > button');

operations.forEach((operation, key) => operation.onclick = (e) => {
    operation.blur();
    switch (operation.textContent) {
        case 'AC':
            resultBoard.value = '';
            break;
        case 'C':
            resultBoard.value = resultBoard.value.length == 0 ? false : resultBoard.value.slice(0, resultBoard.value.length - 1);
            break;
        case '=':
            try {
                const expression = resultBoard.value.replace(/(×|÷)/g, match => (match === '×' ? '*' : '/'));
                const calculate = new Function('return ' + expression);
                const result = calculate();
                resultBoard.value = Number.isInteger(result) ? result : result.toFixed(2);
            } catch (error) {
                resultBoard.value = 'NaN';
            }
            break;
        default:
            resultBoard.value = resultBoard.value === 'NaN' ? operation.textContent : resultBoard.value + operation.textContent;
            break;
    }
});

// ==================== SISTEMA DE SPOTIFY ====================

let spotifyLoggedIn = false;
let spotifyUsername = '';
let currentTrack = null;
let isPlaying = false;
let spotifyPlaylist = [];
let currentTrackIndex = -1;
let progressTimer = null;

// Inicializar app de Spotify
function initSpotifyApp() {
    // Verificar si ya está logueado
    const savedUsername = localStorage.getItem('spotifyUsername');
    if (savedUsername) {
        spotifyLoggedIn = true;
        spotifyUsername = savedUsername;
        showSpotifyMain();
    } else {
        showSpotifyLogin();
    }
    
    // Configurar botones
    const loginBtn = get('#spotifyLoginBtn');
    const searchBtn = get('#spotifySearchBtn');
    const searchInput = get('#spotifySearchInput');
    const playBtn = get('#playerPlay');
    const prevBtn = get('#playerPrev');
    const nextBtn = get('#playerNext');
    const volumeSlider = get('#playerVolume');
    
    if (loginBtn) {
        loginBtn.addEventListener('click', handleSpotifyLogin);
    }
    
    if (searchBtn) {
        searchBtn.addEventListener('click', handleSpotifySearch);
    }
    
    if (searchInput) {
        searchInput.addEventListener('keypress', function(e) {
            if (e.key === 'Enter') {
                handleSpotifySearch();
            }
        });
    }
    
    if (playBtn) {
        playBtn.addEventListener('click', togglePlay);
    }
    
    if (prevBtn) {
        prevBtn.addEventListener('click', playPrevious);
    }
    
    if (nextBtn) {
        nextBtn.addEventListener('click', playNext);
    }
    
    if (volumeSlider) {
        volumeSlider.addEventListener('input', function() {
            const volume = parseInt(this.value);
            updateVolume(volume);
        });
    }
}

// Mostrar pantalla de login
function showSpotifyLogin() {
    const login = get('#spotifyLogin');
    const main = get('#spotifyMain');
    
    if (login) login.style.display = 'flex';
    if (main) main.style.display = 'none';
}

// Mostrar pantalla principal
function showSpotifyMain() {
    const login = get('#spotifyLogin');
    const main = get('#spotifyMain');
    
    if (login) login.style.display = 'none';
    if (main) main.style.display = 'flex';
}

// Manejar login de Spotify
function handleSpotifyLogin() {
    const username = get('#spotifyUsername');
    const password = get('#spotifyPassword');
    
    if (!username || !password) return;
    
    const user = username.value.trim();
    const pass = password.value.trim();
    
    if (!user || !pass) {
        alert('Por favor completa todos los campos');
        return;
    }
    
    // Simular login (en producción, esto se conectaría con la API de Spotify)
    spotifyLoggedIn = true;
    spotifyUsername = user;
    localStorage.setItem('spotifyUsername', user);
    
    showSpotifyMain();
    
    // Limpiar campos
    username.value = '';
    password.value = '';
}

// Buscar música
function handleSpotifySearch() {
    const searchInput = get('#spotifySearchInput');
    const results = get('#spotifyResults');
    
    if (!searchInput || !results) return;
    
    const query = searchInput.value.trim();
    if (!query) return;
    
    // Simular búsqueda (en producción, esto se conectaría con la API de Spotify)
    // Por ahora, mostraremos resultados simulados
    displaySearchResults([
        { title: query + ' - Canción 1', artist: 'Artista 1', url: 'https://example.com/track1.mp3' },
        { title: query + ' - Canción 2', artist: 'Artista 2', url: 'https://example.com/track2.mp3' },
        { title: query + ' - Canción 3', artist: 'Artista 3', url: 'https://example.com/track3.mp3' }
    ]);
}

// Mostrar resultados de búsqueda
function displaySearchResults(tracks) {
    const results = get('#spotifyResults');
    if (!results) return;
    
    results.innerHTML = '';
    spotifyPlaylist = tracks;
    
    tracks.forEach((track, index) => {
        const item = document.createElement('div');
        item.className = 'spotify-result-item';
        item.innerHTML = `
            <div class="spotify-result-artwork">🎵</div>
            <div class="spotify-result-info">
                <div class="spotify-result-title">${track.title}</div>
                <div class="spotify-result-artist">${track.artist}</div>
            </div>
        `;
        item.addEventListener('click', function() {
            playTrack(index);
        });
        results.appendChild(item);
    });
}

// Reproducir track
function playTrack(index) {
    if (index < 0 || index >= spotifyPlaylist.length) return;
    
    currentTrackIndex = index;
    currentTrack = spotifyPlaylist[index];
    
    // Mostrar reproductor
    const player = get('#spotifyPlayer');
    if (player) player.style.display = 'block';
    
    // Actualizar información
    const title = get('#playerTitle');
    const artist = get('#playerArtist');
    
    if (title) title.textContent = currentTrack.title;
    if (artist) artist.textContent = currentTrack.artist;
    
    // Reproducir en el JBL
    if (window.mta && window.mta.triggerEvent) {
        window.mta.triggerEvent('jbl:playFromSpotify', currentTrack.url, currentTrack.title);
    }
    
    isPlaying = true;
    updatePlayButton();
    startProgressTimer();
}

// Toggle play/pause
function togglePlay() {
    isPlaying = !isPlaying;
    updatePlayButton();
    
    if (window.mta && window.mta.triggerEvent) {
        if (isPlaying) {
            window.mta.triggerEvent('jbl:resumeMusic');
        } else {
            window.mta.triggerEvent('jbl:pauseMusic');
        }
    }
}

// Actualizar botón de play
function updatePlayButton() {
    const playBtn = get('#playerPlay');
    if (playBtn) {
        playBtn.textContent = isPlaying ? '⏸' : '▶';
    }
}

// Reproducir anterior
function playPrevious() {
    if (currentTrackIndex > 0) {
        playTrack(currentTrackIndex - 1);
    }
}

// Reproducir siguiente
function playNext() {
    if (currentTrackIndex < spotifyPlaylist.length - 1) {
        playTrack(currentTrackIndex + 1);
    }
}

// Actualizar volumen
function updateVolume(volume) {
    const volumeValue = get('#volumeValue');
    if (volumeValue) {
        volumeValue.textContent = volume + '%';
    }
    
    if (window.mta && window.mta.triggerEvent) {
        window.mta.triggerEvent('jbl:setVolume', volume / 100);
    }
}

// Iniciar temporizador de progreso
function startProgressTimer() {
    if (progressTimer) {
        clearInterval(progressTimer);
    }
    
    let currentSeconds = 0;
    progressTimer = setInterval(function() {
        if (isPlaying && currentTrack) {
            currentSeconds++;
            const minutes = Math.floor(currentSeconds / 60);
            const seconds = currentSeconds % 60;
            const currentTime = get('#currentTime');
            if (currentTime) {
                currentTime.textContent = String(minutes).padStart(2, '0') + ':' + String(seconds).padStart(2, '0');
            }
            
            // Simular progreso (en producción, esto se actualizaría desde el audio real)
            const progressFill = get('#progressFill');
            if (progressFill) {
                // Simular duración total de 180 segundos
                const progress = Math.min((currentSeconds / 180) * 100, 100);
                progressFill.style.width = progress + '%';
            }
        }
    }, 1000);
}

/* Browser App */
let browserHistory = [];
let browserHistoryIndex = -1;

function initBrowserApp() {
    const browserFrame = get('#browserFrame');
    const browserUrlBar = get('#browserUrlBar');
    const browserGoBtn = get('#browserGoBtn');
    const browserBackBtn = get('#browserBackBtn');
    const browserForwardBtn = get('#browserForwardBtn');
    const browserRefreshBtn = get('#browserRefreshBtn');
    const browserHomeScreen = get('#browserHomeScreen');
    const browserShortcuts = getAll('.browser-shortcut');
    
    if (!browserFrame || !browserUrlBar) return;
    
    // Función para navegar a una URL
    function navigateToUrl(url) {
        if (!url) return;
        
        // Validar y formatear URL
        let formattedUrl = url.trim();
        
        // Si no tiene protocolo, agregar https://
        if (!formattedUrl.startsWith('http://') && !formattedUrl.startsWith('https://')) {
            formattedUrl = 'https://' + formattedUrl;
        }
        
        // Validar formato básico de URL
        try {
            new URL(formattedUrl);
        } catch (e) {
            alert('URL inválida. Por favor ingresa una URL válida (ej: google.com)');
            return;
        }
        
        // Agregar a historial
        browserHistory = browserHistory.slice(0, browserHistoryIndex + 1);
        browserHistory.push(formattedUrl);
        browserHistoryIndex = browserHistory.length - 1;
        
        // Limitar historial a 50 entradas
        if (browserHistory.length > 50) {
            browserHistory.shift();
            browserHistoryIndex--;
        }
        
        // Ocultar pantalla de inicio
        if (browserHomeScreen) {
            browserHomeScreen.style.display = 'none';
        }
        
        // Actualizar botones de navegación
        updateBrowserButtons();
        
        // Intentar cargar en iframe primero
        let iframeLoaded = false;
        let loadTimeout;
        
        // Listener para detectar si el iframe carga
        const onIframeLoad = function() {
            iframeLoaded = true;
            clearTimeout(loadTimeout);
            browserFrame.removeEventListener('load', onIframeLoad);
            browserFrame.removeEventListener('error', onIframeError);
        };
        
        // Listener para detectar errores del iframe
        const onIframeError = function() {
            if (!iframeLoaded) {
                clearTimeout(loadTimeout);
                openInSecondaryBrowser(formattedUrl);
                browserFrame.removeEventListener('load', onIframeLoad);
                browserFrame.removeEventListener('error', onIframeError);
            }
        };
        
        browserFrame.addEventListener('load', onIframeLoad);
        browserFrame.addEventListener('error', onIframeError);
        
        // Intentar cargar directamente
        browserFrame.src = formattedUrl;
        browserUrlBar.value = formattedUrl;
        
        // Si después de 2 segundos no carga, abrir navegador secundario
        loadTimeout = setTimeout(function() {
            if (!iframeLoaded) {
                // Verificar si realmente no cargó (puede ser bloqueado por X-Frame-Options)
                try {
                    const iframeDoc = browserFrame.contentDocument || browserFrame.contentWindow.document;
                    if (!iframeDoc || !iframeDoc.body || iframeDoc.body.innerHTML.trim() === '') {
                        openInSecondaryBrowser(formattedUrl);
                    }
                } catch (e) {
                    // Error de CORS/X-Frame-Options, abrir navegador secundario
                    openInSecondaryBrowser(formattedUrl);
                }
            }
            browserFrame.removeEventListener('load', onIframeLoad);
            browserFrame.removeEventListener('error', onIframeError);
        }, 2000);
    }
    
    // Función para abrir URL en navegador secundario
    function openInSecondaryBrowser(url) {
        if (window.mta && window.mta.triggerEvent) {
            window.mta.triggerEvent('phone:browserNavigate', url);
            // Mostrar mensaje al usuario
            const homeScreen = get('#browserHomeScreen');
            if (homeScreen) {
                homeScreen.style.display = 'flex';
                homeScreen.innerHTML = `
                    <div class="browser-logo">🌐</div>
                    <h3>Abriendo en navegador...</h3>
                    <p>La página se abrirá en una ventana separada</p>
                `;
            }
        } else {
            // Fallback: usar proxy de Google Translate
            const proxyUrl = 'https://translate.google.com/translate?sl=auto&tl=es&u=' + encodeURIComponent(url);
            browserFrame.src = proxyUrl;
        }
    }
    
    // Función para actualizar estado de botones de navegación
    function updateBrowserButtons() {
        if (browserBackBtn) {
            browserBackBtn.disabled = browserHistoryIndex <= 0;
            browserBackBtn.style.opacity = browserHistoryIndex <= 0 ? '0.5' : '1';
        }
        if (browserForwardBtn) {
            browserForwardBtn.disabled = browserHistoryIndex >= browserHistory.length - 1;
            browserForwardBtn.style.opacity = browserHistoryIndex >= browserHistory.length - 1 ? '0.5' : '1';
        }
    }
    
    // Event listener para el botón "Ir"
    if (browserGoBtn) {
        browserGoBtn.addEventListener('click', function() {
            const url = browserUrlBar.value;
            navigateToUrl(url);
        });
    }
    
    // Event listener para Enter en la barra de URL
    if (browserUrlBar) {
        browserUrlBar.addEventListener('keypress', function(e) {
            if (e.key === 'Enter') {
                const url = browserUrlBar.value;
                navigateToUrl(url);
            }
        });
    }
    
    // Event listener para botón Atrás
    if (browserBackBtn) {
        browserBackBtn.addEventListener('click', function() {
            if (browserHistoryIndex > 0) {
                browserHistoryIndex--;
                const url = browserHistory[browserHistoryIndex];
                browserFrame.src = url;
                browserUrlBar.value = url;
                updateBrowserButtons();
            }
        });
    }
    
    // Event listener para botón Adelante
    if (browserForwardBtn) {
        browserForwardBtn.addEventListener('click', function() {
            if (browserHistoryIndex < browserHistory.length - 1) {
                browserHistoryIndex++;
                const url = browserHistory[browserHistoryIndex];
                browserFrame.src = url;
                browserUrlBar.value = url;
                updateBrowserButtons();
            }
        });
    }
    
    // Event listener para botón Recargar
    if (browserRefreshBtn) {
        browserRefreshBtn.addEventListener('click', function() {
            if (browserFrame.src && browserFrame.src !== 'about:blank') {
                browserFrame.src = browserFrame.src;
            }
        });
    }
    
    // Event listeners para atajos
    browserShortcuts.forEach(shortcut => {
        shortcut.addEventListener('click', function() {
            const url = this.getAttribute('data-url');
            navigateToUrl(url);
        });
    });
    
    // Mostrar pantalla de inicio si no hay URL cargada
    if (browserFrame.src === 'about:blank' && browserHomeScreen) {
        browserHomeScreen.style.display = 'block';
    }
    
    // Inicializar botones
    updateBrowserButtons();
}

