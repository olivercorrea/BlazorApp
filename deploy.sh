#!/bin/bash

# Detener y eliminar contenedores existentes si existen
docker stop blazor-app-container 2>/dev/null
docker rm blazor-app-container 2>/dev/null

# Construir la imagen Docker para la aplicación Blazor
docker build -t blazor-app .

docker run -d --network host --name blazor-app-container blazor-app

chmod +x monitoreo.sh
./monitoreo.sh

###################################################################################
# echo "Aplicación Blazor en ejecución:"
# echo "http://localhost:8080"

###################################################################################

# # Función para verificar si la aplicación está respondiendo
# check_app() {
#     for i in {1..30}; do
#         if curl -sSf http://localhost:8080 > /dev/null 2>&1; then
#             echo "La aplicación Blazor está respondiendo correctamente."
#             return 0
#         fi
#         echo "Esperando que la aplicación se inicie... (intento $i de 30)"
#         sleep 2
#     done
#     echo "Error: La aplicación Blazor no respondió después de 60 segundos."
#     docker logs blazor-app-container
#     return 1
# }

# # Esperar y verificar si la aplicación está respondiendo
# check_app

# # Si la verificación falla, mostrar información adicional
# if [ $? -ne 0 ]; then
#     echo "Información adicional del contenedor:"
#     docker inspect blazor-app-container
#     echo "Puertos en uso:"
#     netstat -tuln | grep :8080
# fi

# Función para monitorear la aplicación web

###################################################################################

# monitor_web() {
#     if curl -sSf http://localhost:8080 > /dev/null 2>&1; then
#         echo "Aplicación web: Funcionando"
#     else
#         echo "Aplicación web: No responde"
#     fi
# }

# # Función para monitorear el contenedor
# monitor_container() {
#     local stats=$(docker stats --no-stream blazor-app-container)
#     local cpu=$(echo "$stats" | awk 'NR==2 {print $3}')
#     local mem=$(echo "$stats" | awk 'NR==2 {print $4}')
#     echo "Contenedor - CPU: $cpu, RAM: $mem"
# }

# # Función para monitorear el host
# monitor_host() {
#     local cpu=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1"%"}')
#     local mem=$(free -m | awk 'NR==2{printf "%.2f%%", $3*100/$2 }')
#     echo "Host - CPU: $cpu, RAM: $mem"
# }

# # Función principal de monitoreo
# monitor() {
#     while true; do
#         # echo "--- $(date) ---"
#         monitor_web
#         monitor_container
#         monitor_host
#         echo "----------------"
#         sleep 5
#     done
# }

# # Iniciar el monitoreo
# echo "Iniciando monitoreo. Presione Ctrl+C para detener."
# monitor