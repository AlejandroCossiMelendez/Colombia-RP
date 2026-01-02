// Sistema de Velocímetro y Gasolina
// Actualiza el velocímetro en tiempo real con datos del juego

let currentSpeed = 0;
let currentRPM = 0;
let currentFuel = 100;
let engineState = true;
let lightsState = false;
let vehicleName = "Vehículo";

// Función para actualizar el velocímetro
function updateSpeedometer(speed, rpm, fuel, engine, lights, name) {
    currentSpeed = speed || 0;
    currentRPM = rpm || 0;
    currentFuel = fuel || 100;
    engineState = engine !== false;
    lightsState = lights === true;
    vehicleName = name || "Vehículo";
    
    // Actualizar velocidad
    const speedElement = document.getElementById('speed-value');
    if (speedElement) {
        speedElement.textContent = currentSpeed;
    }
    
    // Actualizar RPM
    const rpmElement = document.getElementById('rpm-value');
    if (rpmElement) {
        rpmElement.textContent = currentRPM.toLocaleString();
    }
    
    // Actualizar nombre del vehículo
    const nameElement = document.getElementById('vehicle-name');
    if (nameElement) {
        nameElement.textContent = vehicleName;
    }
    
    // Actualizar estado del motor
    const engineElement = document.getElementById('engine-status');
    if (engineElement) {
        engineElement.textContent = engineState ? 'ON' : 'OFF';
        engineElement.className = 'stat-value ' + (engineState ? 'engine-on' : 'engine-off');
    }
    
    // Actualizar estado de las luces
    const lightsElement = document.getElementById('lights-status');
    if (lightsElement) {
        lightsElement.textContent = lightsState ? 'ON' : 'OFF';
        lightsElement.className = 'stat-value ' + (lightsState ? 'lights-on' : 'lights-off');
    }
    
    // Actualizar aguja de velocidad (0-200 km/h = 0-180 grados)
    const maxSpeed = 200;
    const speedAngle = (currentSpeed / maxSpeed) * 180 - 90; // -90 a 90 grados
    const speedNeedle = document.getElementById('speed-needle');
    if (speedNeedle) {
        speedNeedle.setAttribute('transform', `rotate(${speedAngle} 100 100)`);
    }
    
    // Actualizar arco de velocidad
    const speedArc = document.getElementById('speed-arc');
    if (speedArc) {
        const circumference = 2 * Math.PI * 70; // Radio del arco
        const offset = circumference - (currentSpeed / maxSpeed) * circumference;
        speedArc.setAttribute('stroke-dasharray', `${circumference * (currentSpeed / maxSpeed)} ${circumference}`);
    }
    
    // Actualizar aguja de RPM (0-8000 RPM = 0-180 grados)
    const maxRPM = 8000;
    const rpmAngle = (currentRPM / maxRPM) * 180 - 90;
    const rpmNeedle = document.getElementById('rpm-needle');
    if (rpmNeedle) {
        rpmNeedle.setAttribute('transform', `rotate(${rpmAngle} 100 100)`);
    }
    
    // Actualizar arco de RPM
    const rpmArc = document.getElementById('rpm-arc');
    if (rpmArc) {
        const circumference = 2 * Math.PI * 70;
        rpmArc.setAttribute('stroke-dasharray', `${circumference * (currentRPM / maxRPM)} ${circumference}`);
    }
    
    // Actualizar barra de gasolina
    updateFuelBar(currentFuel);
}

// Función para actualizar la barra de gasolina
function updateFuelBar(fuel) {
    const fuelBar = document.getElementById('fuel-bar');
    const fuelPercentage = document.getElementById('fuel-percentage');
    
    if (fuelBar) {
        fuelBar.style.width = fuel + '%';
        
        // Cambiar color según el nivel
        if (fuel <= 20) {
            fuelBar.style.background = 'linear-gradient(90deg, #ff0000 0%, #ff4400 100%)';
            fuelBar.classList.add('low');
        } else if (fuel <= 50) {
            fuelBar.style.background = 'linear-gradient(90deg, #ff4400 0%, #ffaa00 100%)';
            fuelBar.classList.remove('low');
        } else {
            fuelBar.style.background = 'linear-gradient(90deg, #ffaa00 0%, #00ff00 100%)';
            fuelBar.classList.remove('low');
        }
    }
    
    if (fuelPercentage) {
        fuelPercentage.textContent = Math.round(fuel) + '%';
    }
}

// Función para mostrar el velocímetro
function showSpeedometer() {
    const container = document.getElementById('speedometer-container');
    if (container) {
        container.classList.remove('hidden');
        console.log('Velocímetro mostrado - clase hidden removida');
    } else {
        console.log('ERROR: No se encontró speedometer-container');
    }
}

// Función para ocultar el velocímetro
function hideSpeedometer() {
    const container = document.getElementById('speedometer-container');
    if (container) {
        container.classList.add('hidden');
        console.log('Velocímetro ocultado');
    }
}

// Inicializar: ocultar por defecto
hideSpeedometer();

// Log cuando el script se carga
console.log('Speedometer script cargado');

// Verificar que el DOM esté listo
if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', function() {
        console.log('Speedometer DOM listo');
    });
} else {
    console.log('Speedometer DOM ya estaba listo');
}

// Función global para ser llamada desde Lua
window.updateSpeedometer = updateSpeedometer;
window.showSpeedometer = showSpeedometer;
window.hideSpeedometer = hideSpeedometer;

