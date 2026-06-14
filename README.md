#  Chat_Con_IA — Vulcanizadora Inteligente

Sistema de atención al cliente basado en Inteligencia Artificial para una empresa de vulcanización y neumáticos. Permite consultar servicios, precios y disponibilidad mediante un agente conversacional.

---


##  Notebooks del Proyecto

### RAG1 — Sistema Base de Consultas
Implementa el sistema RAG (Retrieval-Augmented Generation) orientado a la vulcanizadora. El agente responde preguntas sobre servicios, precios y horarios usando un contexto estructurado. Incluye técnicas de **zero-shot** y **few-shot prompting** para mejorar la precisión de las respuestas.

### Notebook1 — Zero-Shot y Few-Shot
Exploración de técnicas de prompting. Zero-shot permite responder sin ejemplos previos, mientras que few-shot guía al modelo con ejemplos específicos del dominio de vulcanización.

### Notebook_Chain_of_Thought
Implementación de cadena de pensamiento (Chain of Thought) para que el agente razone paso a paso antes de responder, mejorando la calidad de respuestas complejas.

### RAG3 — Observabilidad y Métricas
Sistema de monitoreo del agente con logging estructurado, recolección de métricas (tiempo de respuesta, tokens usados, tasa de errores) y clasificación automática de consultas por tipo de servicio.

### RAG4 — Notificaciones por Email
Módulo de envío automático de reportes por correo usando Gmail SMTP con diseño HTML profesional, incluyendo métricas del sistema y resumen de consultas atendidas.

### RAG5 — Seguridad y Ética *(en desarrollo)*
Capa de seguridad con detección de PII, filtro ético por categorías, rate limiting y sanitización contra prompt injection.


### RAG5 — Seguridad y Ética
Capa de seguridad completa del agente con:
- **Evaluación matemática segura** usando AST sin `eval()` peligroso
- **Detección y sanitización de PII** (correos, teléfonos, RUT, tarjetas)
- **Filtro ético** por categorías (violencia, manipulación, contenido ilegal)
- **Rate limiting** para prevenir abuso (máx. 10 peticiones por minuto)
- **Sanitización contra prompt injection** bloqueando instrucciones maliciosas

### Interfaz Web (Flask)

Aplicación web que integra los módulos RAG1, RAG3, RAG4 y RAG5 en una interfaz unificada para el sistema de atención de la vulcanizadora.

**Componentes de la interfaz:**
- **Chat interactivo** que procesa consultas mediante la clase `AgenteVulcanizadora`, combinando el contexto RAG de vulcanización con las capas de seguridad (sanitización, filtro ético, detección de PII, rate limiting) y observabilidad (logging, métricas)
- **Panel de métricas en vivo** que muestra total de consultas, tiempo promedio de respuesta, tasa de errores y tokens utilizados, actualizado automáticamente tras cada interacción
- **Botón de envío de reporte** por correo electrónico con el historial de consultas y las métricas actuales del sistema

**Rutas disponibles:**

| Ruta | Método | Descripción |
|------|--------|-------------|
| `/` | GET | Interfaz principal de chat |
| `/chat` | POST | Procesamiento de consultas (recibe JSON con `mensaje`, retorna `respuesta` y `tipo_consulta`) |
| `/metricas` | GET | Obtención de métricas del sistema en formato JSON |
| `/enviar-reporte` | POST | Envío de reporte por correo con métricas e historial |

**Instrucciones de ejecución:**

```powershell
# Activar el entorno virtual
.\.venv\Scripts\Activate.ps1

# Ejecutar la aplicación
.\.venv\Scripts\python app.py
```

Acceder desde el navegador a [http://127.0.0.1:5000](http://127.0.0.1:5000).

**Archivos relacionados:**
- `app.py` — aplicación Flask principal con la clase `AgenteVulcanizadora`
- `templates/index.html` — interfaz de usuario con chat y panel de métricas
- `static/style.css` — estilos responsive con paleta profesional
- `requirements_flask.txt` — dependencia adicional (Flask) para el proyecto

---

##  Tecnologías

| Tecnología | Uso |
|---|---|
| Python 3.11 | Lenguaje principal |
| GitHub Models (GPT-4.1) | Modelo de lenguaje |
| LangSmith | Trazabilidad de agentes |
| Flask | Interfaz web implementada |
| Gmail SMTP | Notificaciones por email |

---

##  Diagramas del Proyecto

### Diagrama de Arquitectura
Visualiza la arquitectura completa del sistema: capas de usuario, interfaz web, seguridad, agente RAG, sistema de recuperación, modelo IA, observabilidad y notificaciones. Incluye diagrama general, flujo de secuencia, mapa de tecnologías y tabla de componentes.
> [`architecture-diagram.html`](./architecture-diagram.html)

### Diagrama de Orquestación de Componentes
Muestra cómo el orquestador central (LangChain/LangGraph) coordina todos los componentes del sistema: cadena de seguridad, motor RAG, razonamiento del LLM, observabilidad, notificaciones y herramientas del agente. Incluye diagrama general, secuencia temporal, pipeline con puntos de decisión y orquestación del agente multi-herramienta.
> [`orchestration-diagram.html`](./orchestration-diagram.html)

---

##  Despliegue en AWS

### Demo en vivo

La aplicación está desplegada y accesible públicamente en:

- **URL:** [http://54.147.28.132:5000](http://54.147.28.132:5000)

> **Nota:** El servicio corre sobre una instancia EC2 de **AWS Academy Learner Lab**, por lo que la disponibilidad puede estar sujeta a los límites de sesión del laboratorio educativo. La URL puede no estar activa fuera de los horarios de evaluación o demo coordinados.

### Stack de despliegue

| Componente | Detalle |
|---|---|
| Cloud provider | AWS (EC2, Academy Learner Lab) |
| Sistema operativo | Amazon Linux 2023 |
| Tipo de instancia | t3.micro |
| Región | us-east-1 |
| IP fija | Elastic IP |
| Gestión del proceso | systemd (`vulcanizadora.service`, `Restart=always`, habilitado para arranque automático) |
| Framework web | Flask, expuesto en puerto 5000, escuchando en `0.0.0.0` |

### Cómo reproducir el despliegue (Setup en servidor)

```bash
# 1. Clonar el repositorio
git clone https://github.com/Jesusjacv1/Chat_Con_ia.git
cd Chat_Con_ia

# 2. Instalar dependencias del sistema (Amazon Linux 2023)
sudo dnf install -y python3-pip python3-devel git

# 3. Instalar dependencias Python
pip3 install --user flask openai python-dotenv

# 4. Crear archivo .env con las variables de entorno necesarias
#    (NO subir al repositorio — .env ya está en .gitignore)
cat > .env << EOF
GITHUB_TOKEN=tu_token_aqui
OPENAI_BASE_URL=tu_base_url_aqui
LANGSMITH_API_KEY=tu_langsmith_api_key
LANGSMITH_TRACING=true
LANGSMITH_PROJECT=tu_proyecto
GMAIL_USER=tu_correo@gmail.com
GMAIL_APP_PASSWORD=tu_contraseña_app
EMAIL_DESTINO=destino@correo.com
EOF

# 5. Ejecutar la aplicación (modo desarrollo)
python3 app.py

# — O configurar como servicio systemd para producción —
# sudo nano /etc/systemd/system/vulcanizadora.service
# sudo systemctl enable vulcanizadora.service
# sudo systemctl start vulcanizadora.service
```

### Arquitectura del despliegue

```
Usuario (navegador)
       │
       ▼
  Elastic IP :5000
       │
       ▼
  EC2 — Amazon Linux 2023
       │
       ▼
  systemd → vulcanizadora.service
       │
       ▼
  Flask App (app.py)
       │
       ├──► GPT-4.1 (GitHub Models / Azure)
       ├──► LangSmith (observabilidad)
       └──► SMTP Gmail (reportes por correo)
```

---

##  Autor

**Jesús Cárdenas**  
Estudiante de Ingeniería en Informática — Duoc UC Puerto Montt  
GitHub: [@Jesusjacv1](https://github.com/Jesusjacv1)