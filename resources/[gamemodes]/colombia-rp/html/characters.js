let charactersData = [];
let deleteCharacterId = null;

function loadCharacters(characters) {
    charactersData = characters || [];
    const container = document.getElementById('charactersList');
    container.innerHTML = '';
    
    if (charactersData.length === 0) {
        container.innerHTML = '<div style="grid-column: 1/-1; text-align: center; color: rgba(255,255,255,0.5); padding: 40px;">No tienes personajes creados</div>';
        return;
    }
    
    charactersData.forEach(char => {
        const card = document.createElement('div');
        card.className = 'character-card';
        card.innerHTML = `
            <div class="character-name">${char.name} ${char.surname}</div>
            <div class="character-info">
                <strong>Edad:</strong> ${char.age} años
            </div>
            <div class="character-info">
                <strong>Dinero:</strong> $${formatNumber(char.money || 0)}
            </div>
            <div class="character-info">
                <strong>Último login:</strong> ${formatDate(char.lastLogin) || 'Nunca'}
            </div>
            <div class="character-actions">
                <button class="btn-character btn-select" onclick="selectCharacter(${char.id})">Seleccionar</button>
                <button class="btn-character btn-delete-char" onclick="showDeleteModal(${char.id})">Eliminar</button>
            </div>
        `;
        container.appendChild(card);
    });
}

function formatNumber(num) {
    return num.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ".");
}

function formatDate(dateString) {
    if (!dateString) return null;
    try {
        const date = new Date(dateString);
        return date.toLocaleDateString('es-ES', { 
            year: 'numeric', 
            month: 'short', 
            day: 'numeric',
            hour: '2-digit',
            minute: '2-digit'
        });
    } catch (e) {
        return dateString;
    }
}

function selectCharacter(id) {
    if (window.mta) {
        window.mta.triggerEvent('selectCharacter', id);
    } else {
        console.error('MTA no está disponible');
        showError('Error de conexión con el juego');
    }
}

function showDeleteModal(id) {
    deleteCharacterId = id;
    document.getElementById('deleteModal').classList.add('active');
}

function hideDeleteModal() {
    deleteCharacterId = null;
    document.getElementById('deleteModal').classList.remove('active');
}

function confirmDelete() {
    if (deleteCharacterId !== null) {
        if (window.mta) {
            window.mta.triggerEvent('deleteCharacter', deleteCharacterId);
        } else {
            console.error('MTA no está disponible');
            showError('Error de conexión con el juego');
        }
        hideDeleteModal();
    }
}

function showCreateModal() {
    document.getElementById('createModal').classList.add('active');
    // Limpiar formulario
    document.getElementById('charName').value = '';
    document.getElementById('charSurname').value = '';
    document.getElementById('charAge').value = '25';
    document.getElementById('charGender').value = '0';
    document.getElementById('charSkin').value = '0';
}

function hideCreateModal() {
    document.getElementById('createModal').classList.remove('active');
}

function createCharacter(e) {
    e.preventDefault();
    
    const name = document.getElementById('charName').value.trim();
    const surname = document.getElementById('charSurname').value.trim();
    const age = parseInt(document.getElementById('charAge').value);
    const gender = parseInt(document.getElementById('charGender').value);
    const skin = parseInt(document.getElementById('charSkin').value) || 0;
    
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
    
    if (age < 18 || age > 100) {
        showError('La edad debe estar entre 18 y 100 años');
        return;
    }
    
    if (window.mta) {
        window.mta.triggerEvent('createCharacter', name, surname, age, gender, skin);
        hideCreateModal();
    } else {
        console.error('MTA no está disponible');
        showError('Error de conexión con el juego');
    }
}

function showError(message) {
    const msgEl = document.getElementById('message');
    msgEl.textContent = message;
    msgEl.className = 'message error';
    msgEl.style.display = 'block';
    setTimeout(() => {
        msgEl.style.display = 'none';
    }, 5000);
}

function showSuccess(message) {
    const msgEl = document.getElementById('message');
    msgEl.textContent = message;
    msgEl.className = 'message success';
    msgEl.style.display = 'block';
    setTimeout(() => {
        msgEl.style.display = 'none';
    }, 5000);
}

// Funciones expuestas para MTA
window.loadCharacters = loadCharacters;
window.showError = showError;
window.showSuccess = showSuccess;

// Cerrar modal al hacer clic fuera
document.addEventListener('click', function(e) {
    const modals = document.querySelectorAll('.modal.active');
    modals.forEach(modal => {
        if (e.target === modal) {
            modal.classList.remove('active');
        }
    });
});

