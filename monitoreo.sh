monitor_web() {
    if curl -sSf http://localhost:8080 > /dev/null 2>&1; then
        echo "Aplicación web: Funcionando"
    else
        echo "Aplicación web: No responde"
    fi
}

# Función para monitorear el contenedor
monitor_container() {
    local stats=$(docker stats --no-stream blazor-app-container)
    local cpu=$(echo "$stats" | awk 'NR==2 {print $3}')
    local mem=$(echo "$stats" | awk 'NR==2 {print $4}')
    echo "Contenedor - CPU: $cpu, RAM: $mem"
}

# Función para monitorear el host
monitor_host() {
    local cpu=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1"%"}')
    local mem=$(free -m | awk 'NR==2{printf "%.2f%%", $3*100/$2 }')
    echo "Host - CPU: $cpu, RAM: $mem"
}

# Función principal de monitoreo
monitor() {
    while true; do
        # echo "--- $(date) ---"
        monitor_web
        monitor_container
        monitor_host
        echo "----------------"
        sleep 5
    done
}

# Iniciar el monitoreo
echo "Iniciando monitoreo. Presione Ctrl+C para detener."
monitor