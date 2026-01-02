// Función para cargar personajes
function loadCharacters(characters) {
    const container = document.getElementById('characters');
    
    // Limpiar contenedor
    container.innerHTML = '';
    
    // Agregar tarjeta de crear personaje
    const createCard = document.createElement('div');
    createCard.className = 'character-card create-card';
    createCard.onclick = showCreateModal;
    createCard.innerHTML = `
        <div class="create-icon">+</div>
        <div class="create-text">Crear Nuevo Personaje</div>
    `;
    container.appendChild(createCard);
    
    // Agregar personajes
    if (characters && characters.length > 0) {
        characters.forEach(char => {
            const card = document.createElement('div');
            card.className = 'character-card';
            card.innerHTML = `
                <div class="character-name">${char.name || ''} ${char.surname || ''}</div>
                <div class="character-info">Edad: ${char.age || 18} años</div>
                <div class="character-info">Dinero: $${formatMoney(char.money || 0)}</div>
                <div class="character-info">Último login: ${char.lastLogin || 'Nunca'}</div>
                <div class="card-actions">
                    <button class="btn btn-primary" onclick="selectCharacter(${char.id}, event)">Seleccionar</button>
                </div>
            `;
            container.appendChild(card);
        });
    }
}

// Función para formatear dinero
function formatMoney(amount) {
    return amount.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}

// Función para seleccionar personaje
function selectCharacter(id, event) {
    if (event) {
        event.stopPropagation();
    }
    
    if (window.mta) {
        window.mta.triggerEvent('selectCharacter', id);
    } else {
        console.error('MTA no está disponible');
        showError('Error de conexión con el juego');
    }
}


// Función para mostrar modal de crear personaje
function showCreateModal() {
    document.getElementById('createModal').classList.add('active');
    hideMessage();
}

// Función para ocultar modal
function hideCreateModal() {
    document.getElementById('createModal').classList.remove('active');
    // Cerrar dropdown si está abierto
    closeGenderDropdown();
    // Limpiar formulario
    document.getElementById('charName').value = '';
    document.getElementById('charSurname').value = '';
    document.getElementById('charAge').value = '25';
    document.getElementById('charGender').value = '0';
    document.getElementById('genderDisplay').textContent = 'Masculino';
    // Resetear selección de género
    document.querySelectorAll('.select-option').forEach((option, index) => {
        if (index === 0) {
            option.classList.add('selected');
        } else {
            option.classList.remove('selected');
        }
    });
}

// Funciones para el selector personalizado de género
function toggleGenderDropdown() {
    const customSelect = document.querySelector('.custom-select');
    const isActive = customSelect.classList.contains('active');
    
    // Cerrar otros dropdowns si están abiertos
    document.querySelectorAll('.custom-select').forEach(select => {
        if (select !== customSelect) {
            select.classList.remove('active');
        }
    });
    
    // Toggle del dropdown actual
    if (isActive) {
        customSelect.classList.remove('active');
    } else {
        customSelect.classList.add('active');
    }
}

function closeGenderDropdown() {
    document.querySelectorAll('.custom-select').forEach(select => {
        select.classList.remove('active');
    });
}

function selectGender(value, text, event) {
    document.getElementById('charGender').value = value;
    document.getElementById('genderDisplay').textContent = text;
    closeGenderDropdown();
    
    // Actualizar clase selected en las opciones
    document.querySelectorAll('.select-option').forEach(option => {
        option.classList.remove('selected');
    });
    if (event && event.target) {
        event.target.classList.add('selected');
    }
}

// Función para crear personaje
function createCharacter(e) {
    e.preventDefault();
    
    const name = document.getElementById('charName').value.trim();
    const surname = document.getElementById('charSurname').value.trim();
    const age = parseInt(document.getElementById('charAge').value);
    const genderSelect = document.getElementById('charGender');
    const gender = parseInt(genderSelect.value);
    
    if (!name || !surname) {
        showError('Por favor completa todos los campos');
        return;
    }
    
    if (name.length < 2 || name.length > 20) {
        showError('El nombre debe tener entre 2 y 20 caracteres');
        return;
    }
    
    if (surname.length < 2 || surname.length > 20) {
        showError('El apellido debe tener entre 2 y 20 caracteres');
        return;
    }
    
    if (!age || age < 18 || age > 100) {
        showError('La edad debe estar entre 18 y 100 años');
        return;
    }
    
    // Asignar skin según el género: 0 = masculino (skin 0), 1 = femenino (skin 216)
    const skin = (gender === 0) ? 0 : 216;
    
    // Validar que gender sea un número válido
    if (isNaN(gender) || (gender !== 0 && gender !== 1)) {
        showError('Por favor selecciona un género válido');
        return;
    }
    
    console.log('Enviando createCharacter:', { name, surname, age, gender, skin });
    
    if (window.mta && window.mta.triggerEvent) {
        try {
            window.mta.triggerEvent('createCharacter', name, surname, age, gender, skin);
            console.log('Evento createCharacter enviado correctamente');
            hideCreateModal();
        } catch (error) {
            console.error('Error al enviar evento:', error);
            showError('Error al enviar los datos. Intenta nuevamente.');
        }
    } else {
        console.error('MTA no está disponible o triggerEvent no existe');
        showError('Error de conexión con el juego');
    }
}

// Funciones de mensajes
let messageTimeout;

function showError(message) {
    const msgEl = document.getElementById('message');
    msgEl.textContent = message;
    msgEl.className = 'message error';
    msgEl.style.display = 'block';
    clearTimeout(messageTimeout);
    messageTimeout = setTimeout(hideMessage, 5000);
}

function showSuccess(message) {
    const msgEl = document.getElementById('message');
    msgEl.textContent = message;
    msgEl.className = 'message success';
    msgEl.style.display = 'block';
    clearTimeout(messageTimeout);
    messageTimeout = setTimeout(hideMessage, 3000);
}

function hideMessage() {
    const msgEl = document.getElementById('message');
    msgEl.style.display = 'none';
}

// Cerrar modal al hacer clic fuera
document.addEventListener('click', function(e) {
    const modal = document.getElementById('createModal');
    if (e.target === modal) {
        hideCreateModal();
    }
    
    // Cerrar dropdown si se hace clic fuera
    const customSelect = document.querySelector('.custom-select');
    if (customSelect && !customSelect.contains(e.target)) {
        closeGenderDropdown();
    }
});

// Funciones expuestas para MTA
window.loadCharacters = loadCharacters;
window.showError = showError;
window.showSuccess = showSuccess;
window.hideMessage = hideMessage;
window.selectCharacter = selectCharacter;
window.createCharacter = createCharacter;
window.showCreateModal = showCreateModal;
window.hideCreateModal = hideCreateModal;
window.toggleGenderDropdown = toggleGenderDropdown;
window.selectGender = selectGender;
window.closeGenderDropdown = closeGenderDropdown;

