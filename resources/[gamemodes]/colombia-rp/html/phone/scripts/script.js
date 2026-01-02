"use strict";

const get = (element) => { return document.querySelector(element) };
const getAll = (element) => { return document.querySelectorAll(element) };

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
    // Si ya está en el home, cerrar el teléfono
    if (isInHomeScreen) {
        // Cerrar el teléfono enviando evento a MTA
        if (window.mta) {
            window.mta.triggerEvent('closePhoneFromBrowser');
        }
        return;
    }
    // Si está en una app, volver al home
    if (lock) lock.style.display = 'none';
    if (unlock) unlock.style.display = 'flex';
    if (interfaces) interfaces.style.display = 'none';
    appsInterfaces.forEach(e => e.style.display = 'none');
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
        contactItem.innerHTML = `
            <div class="contact-avatar">${contact.name.charAt(0).toUpperCase()}</div>
            <div class="contact-info">
                <div class="contact-name">${contact.name}</div>
                <div class="contact-number">${contact.number}</div>
            </div>
            <button class="delete-contact" onclick="deleteContact(${index})">×</button>
        `;
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
    const name = get('#contactName').value.trim();
    const number = get('#contactNumber').value.trim();
    
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
    
    contacts.push({ name, number });
    loadContacts();
    hideAddContactForm();
    
    // Guardar en MTA (opcional, para persistencia)
    if (window.mta) {
        window.mta.triggerEvent('saveContacts', JSON.stringify(contacts));
    }
}

// Función para eliminar contacto
function deleteContact(index) {
    if (confirm('¿Eliminar este contacto?')) {
        contacts.splice(index, 1);
        loadContacts();
        
        // Guardar en MTA
        if (window.mta) {
            window.mta.triggerEvent('saveContacts', JSON.stringify(contacts));
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

