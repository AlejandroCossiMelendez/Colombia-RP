function switchTab(tab) {
    const loginTab = document.getElementById('loginTab');
    const registerTab = document.getElementById('registerTab');
    const loginPanel = document.getElementById('loginPanel');
    const registerPanel = document.getElementById('registerPanel');
    
    if (tab === 'login') {
        loginTab.classList.add('active');
        registerTab.classList.remove('active');
        loginPanel.classList.add('active');
        registerPanel.classList.remove('active');
    } else {
        loginTab.classList.remove('active');
        registerTab.classList.add('active');
        loginPanel.classList.remove('active');
        registerPanel.classList.add('active');
    }
    
    hideMessage();
}

function doLogin(e) {
    e.preventDefault();
    
    const username = document.getElementById('loginUsername').value.trim();
    const password = document.getElementById('loginPassword').value;
    
    if (!username || !password) {
        showError('Por favor completa todos los campos');
        return;
    }
    
    if (username.length < 3) {
        showError('El usuario debe tener al menos 3 caracteres');
        return;
    }
    
    setLoading('loginBtn', true);
    hideMessage();
    
    // Enviar evento a MTA
    if (window.mta) {
        window.mta.triggerEvent('doLogin', username, password);
    } else {
        console.error('MTA no está disponible');
        setLoading('loginBtn', false);
        showError('Error de conexión con el juego');
    }
}

function doRegister(e) {
    e.preventDefault();
    
    const username = document.getElementById('registerUsername').value.trim();
    const email = document.getElementById('registerEmail').value.trim();
    const password = document.getElementById('registerPassword').value;
    const confirmPassword = document.getElementById('confirmPassword').value;
    
    if (!username || !password || !email || !confirmPassword) {
        showError('Por favor completa todos los campos');
        return;
    }
    
    if (username.length < 3 || username.length > 20) {
        showError('El usuario debe tener entre 3 y 20 caracteres');
        return;
    }
    
    if (password.length < 6) {
        showError('La contraseña debe tener al menos 6 caracteres');
        return;
    }
    
    if (password !== confirmPassword) {
        showError('Las contraseñas no coinciden');
        return;
    }
    
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailRegex.test(email)) {
        showError('Email inválido');
        return;
    }
    
    setLoading('registerBtn', true);
    hideMessage();
    
    // Enviar evento a MTA
    if (window.mta) {
        window.mta.triggerEvent('doRegister', username, password, email);
    } else {
        console.error('MTA no está disponible');
        setLoading('registerBtn', false);
        showError('Error de conexión con el juego');
    }
}

function showError(message) {
    const msgEl = document.getElementById('message');
    msgEl.textContent = message;
    msgEl.className = 'message error';
    msgEl.style.display = 'block';
}

function showSuccess(message) {
    const msgEl = document.getElementById('message');
    msgEl.textContent = message;
    msgEl.className = 'message success';
    msgEl.style.display = 'block';
}

function hideMessage() {
    const msgEl = document.getElementById('message');
    msgEl.style.display = 'none';
}

function setLoading(btnId, loading) {
    const btn = document.getElementById(btnId);
    const span = btn.querySelector('span');
    
    if (loading) {
        span.innerHTML = 'Procesando<span class="loading"></span>';
        btn.disabled = true;
    } else {
        if (btnId === 'loginBtn') {
            span.textContent = 'Login';
        } else {
            span.textContent = 'Register';
        }
        btn.disabled = false;
    }
}

function showSettings() {
    alert('Configuración - Próximamente');
}

function showAbout() {
    alert('Colombia RP\nVersión 1.0\nGamemode moderno con MySQL');
}

function quitGame() {
    if (window.mta) {
        window.mta.triggerEvent('quitGame');
    }
}

// Funciones expuestas para MTA
window.showError = showError;
window.showSuccess = showSuccess;
window.setLoading = setLoading;
window.hideMessage = hideMessage;
window.switchTab = switchTab;

