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
    
    // Agregar eventos de arrastre para cerrar el teléfono
    setupDragToClose();
}

// Función para configurar el gesto de arrastre hacia abajo para cerrar
function setupDragToClose() {
    const iphone = get('.iphone');
    if (!iphone) return;
    
    // Área superior del teléfono donde se puede arrastrar (notch y área superior)
    const dragArea = document.createElement('div');
    dragArea.style.position = 'absolute';
    dragArea.style.top = '0';
    dragArea.style.left = '0';
    dragArea.style.right = '0';
    dragArea.style.height = '80px';
    dragArea.style.zIndex = '1000';
    dragArea.style.cursor = 'grab';
    dragArea.style.userSelect = 'none';
    iphone.appendChild(dragArea);
    
    // Evento cuando se presiona el mouse/touch
    dragArea.addEventListener('mousedown', handleDragStart);
    dragArea.addEventListener('touchstart', handleDragStart, { passive: false });
    
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
        
        // Guardar contactos antes de cerrar
        saveContactsToMTA();
        
        // Animación de cierre suave
        iphone.style.transition = 'transform 0.4s ease-out, opacity 0.4s ease-out, filter 0.4s ease-out';
        iphone.style.transform = 'translateY(400px)';
        iphone.style.opacity = '0';
        iphone.style.filter = 'brightness(0.5)';
        
        // Cerrar el teléfono después de la animación
        setTimeout(function() {
            if (window.mta && window.mta.triggerEvent) {
                window.mta.triggerEvent('closePhoneFromBrowser');
            }
            // Resetear estilos
            if (iphone) {
                iphone.style.transform = 'translateY(0)';
                iphone.style.opacity = '1';
                iphone.style.filter = 'brightness(1)';
            }
            isClosing = false;
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
    if (window.mta && window.mta.triggerEvent && contacts.length > 0) {
        try {
            window.mta.triggerEvent('saveContacts', JSON.stringify(contacts));
            console.log('Contactos guardados al cerrar el teléfono');
        } catch (e) {
            console.error('Error al guardar contactos:', e);
        }
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
}

let isInHomeScreen = true; // Variable para rastrear si estamos en el home

function returnToHomePage() {
    // Verificar si realmente estamos en el home (unlock visible y no hay apps abiertas)
    const unlockVisible = unlock && unlock.style.display !== 'none' && unlock.style.display !== '';
    const interfacesVisible = interfaces && (interfaces.style.display === 'block' || interfaces.style.display === 'flex');
    
    // Si ya está en el home (unlock visible y interfaces ocultas), cerrar el teléfono
    if (unlockVisible && !interfacesVisible) {
        // Guardar contactos antes de cerrar
        saveContactsToMTA();
        
        // Cerrar el teléfono enviando evento a MTA
        if (window.mta && window.mta.triggerEvent) {
            window.mta.triggerEvent('closePhoneFromBrowser');
        } else {
            console.error('MTA no está disponible');
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

/* Contacts App */
let contacts = [];
let myPhoneNumber = '';

// Función para recibir el número de teléfono desde MTA
function setMyPhoneNumber(number) {
    myPhoneNumber = number;
    loadContacts();
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
        
        const deleteBtn = document.createElement('button');
        deleteBtn.className = 'delete-contact';
        deleteBtn.textContent = '×';
        deleteBtn.onclick = function(e) {
            e.stopPropagation(); // Prevenir que se propague el evento
            deleteContact(index);
        };
        
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
        
        contactItem.appendChild(avatar);
        contactItem.appendChild(info);
        contactItem.appendChild(deleteBtn);
        
        contactsList.appendChild(contactItem);
    });
}

// Función para mostrar formulario de agregar contacto
function showAddContactForm() {
    const form = get('#addContactForm');
    if (form) {
        form.style.display = 'block';
        get('#contactName').value = '';
        get('#contactNumber').value = '';
    }
}

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
    
    // Guardar en MTA (opcional, para persistencia)
    if (window.mta && window.mta.triggerEvent) {
        try {
            window.mta.triggerEvent('saveContacts', JSON.stringify(contacts));
            console.log('Contactos guardados en MTA');
        } catch (e) {
            console.error('Error al guardar contactos:', e);
        }
    } else {
        console.warn('MTA no está disponible, los contactos se guardarán solo en memoria');
    }
}

// Función para eliminar contacto
function deleteContact(index) {
    console.log('deleteContact llamado con índice:', index);
    console.log('Contactos antes de eliminar:', contacts);
    
    if (index === undefined || index === null || isNaN(index)) {
        console.error('Índice inválido:', index);
        return;
    }
    
    if (index < 0 || index >= contacts.length) {
        console.error('Índice fuera de rango:', index, 'Total contactos:', contacts.length);
        return;
    }
    
    const contactToDelete = contacts[index];
    if (!contactToDelete) {
        console.error('Contacto no encontrado en el índice:', index);
        return;
    }
    
    if (confirm('¿Eliminar el contacto "' + contactToDelete.name + '"?')) {
        contacts.splice(index, 1);
        console.log('Contacto eliminado. Contactos restantes:', contacts);
        loadContacts();
        
        // Guardar en MTA
        if (window.mta && window.mta.triggerEvent) {
            try {
                window.mta.triggerEvent('saveContacts', JSON.stringify(contacts));
                console.log('Contactos guardados después de eliminar');
            } catch (e) {
                console.error('Error al guardar contactos:', e);
            }
        }
    }
}

// Exponer funciones para MTA
window.setMyPhoneNumber = setMyPhoneNumber;
window.loadContacts = loadContacts;

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

