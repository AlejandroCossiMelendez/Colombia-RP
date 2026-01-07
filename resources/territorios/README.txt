==========================================
   SISTEMA DE TERRITORIOS - LA CAPITAL RP
==========================================

INSTALACIÓN:
1. Ejecutar database.sql en phpMyAdmin
2. Copiar carpeta territorios/ a /resources/
3. Agregar <resource src="territorios" startup="1" /> a server.conf
4. Reiniciar servidor

ARCHIVOS:
- database.sql (base de datos)
- server.lua (sistema principal)
- client.lua (radar y efectos)
- config.lua (configuración)
- meta.xml (resource config)

COMANDOS:
/territorios → Lista territorios
/atacar     → Atacar territorio
/territorio → Info zona actual
/batalla    → Estado batalla

ADMIN:
/aterr reload → Recargar sistema
/aterr reset <id> → Liberar territorio

CARACTERÍSTICAS:
- Solo facciones ilegales
- Ganancias $12M/hora por territorio
- Solo con jugadores online
- Batallas múltiples (hasta 4 facciones)
- Radar con colores por facción

CONFIGURAR:
Editar config.lua para:
- Agregar facciones
- Cambiar ganancias
- Modificar colores
- Ajustar tiempos
