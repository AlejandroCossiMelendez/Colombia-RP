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
                    <button class="btn btn-danger" onclick="deleteCharacter(${char.id}, event)">Eliminar</button>
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

// Función para eliminar personaje
function deleteCharacter(id, event) {
    if (event) {
        event.stopPropagation();
    }
    
    if (confirm('¿Estás seguro de eliminar este personaje? Esta acción no se puede deshacer.')) {
        if (window.mta) {
            window.mta.triggerEvent('deleteCharacter', id);
        } else {
            console.error('MTA no está disponible');
            showError('Error de conexión con el juego');
        }
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
    // Limpiar formulario
    document.getElementById('charName').value = '';
    document.getElementById('charSurname').value = '';
    document.getElementById('charAge').value = '25';
    document.getElementById('charGender').value = '0';
}

// Función para crear personaje
function createCharacter(e) {
    e.preventDefault();
    
    const name = document.getElementById('charName').value.trim();
    const surname = document.getElementById('charSurname').value.trim();
    const age = parseInt(document.getElementById('charAge').value);
    const gender = parseInt(document.getElementById('charGender').value);
    
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
    
    if (window.mta) {
        window.mta.triggerEvent('createCharacter', name, surname, age, gender, 0);
        hideCreateModal();
    } else {
        console.error('MTA no está disponible');
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
});

// Funciones expuestas para MTA
window.loadCharacters = loadCharacters;
window.showError = showError;
window.showSuccess = showSuccess;
window.hideMessage = hideMessage;
window.selectCharacter = selectCharacter;
window.deleteCharacter = deleteCharacter;
window.createCharacter = createCharacter;
window.showCreateModal = showCreateModal;
window.hideCreateModal = hideCreateModal;

