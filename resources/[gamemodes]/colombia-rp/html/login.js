function focusLogin() {
    const loginTab = document.querySelector('.tab:first-child');
    const registerTab = document.querySelector('.tab:last-child');
    
    if (loginTab && registerTab) {
        loginTab.classList.add('active');
        registerTab.classList.remove('active');
    }
    
    // Scroll suave al panel de login (opcional)
    const loginPanel = document.querySelector('.login-panel');
    if (loginPanel) {
        loginPanel.scrollIntoView({ behavior: 'smooth', block: 'nearest' });
    }
}

function focusRegister() {
    const loginTab = document.querySelector('.tab:first-child');
    const registerTab = document.querySelector('.tab:last-child');
    
    if (loginTab && registerTab) {
        loginTab.classList.remove('active');
        registerTab.classList.add('active');
    }
    
    // Scroll suave al panel de register (opcional)
    const registerPanel = document.querySelector('.register-panel');
    if (registerPanel) {
        registerPanel.scrollIntoView({ behavior: 'smooth', block: 'nearest' });
    }
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
    msgEl.className = 'error';
    msgEl.style.display = 'block';
    setTimeout(hideMessage, 5000);
}

function showSuccess(message) {
    const msgEl = document.getElementById('message');
    msgEl.textContent = message;
    msgEl.className = 'success';
    msgEl.style.display = 'block';
    setTimeout(hideMessage, 3000);
}

function hideMessage() {
    const msgEl = document.getElementById('message');
    msgEl.style.display = 'none';
}

function setLoading(btnId, loading) {
    const btn = document.getElementById(btnId);
    
    if (!btn) return;
    
    if (loading) {
        btn.disabled = true;
        btn.textContent = 'Procesando...';
    } else {
        btn.disabled = false;
        if (btnId === 'loginBtn') {
            btn.textContent = 'Login';
        } else {
            btn.textContent = 'Register';
        }
    }
}


// Funciones expuestas para MTA
window.showError = showError;
window.showSuccess = showSuccess;
window.setLoading = setLoading;
window.hideMessage = hideMessage;
window.focusLogin = focusLogin;
window.focusRegister = focusRegister;
