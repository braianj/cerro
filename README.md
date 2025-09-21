# Galería de Imágenes Fotiar

Una galería web moderna para visualizar imágenes con filtros avanzados y funcionalidades de búsqueda.

## Características

- 🖼️ **Galería de imágenes** con vista de cuadrícula responsiva
- 🔍 **Filtros avanzados** por fecha, fotógrafo y etiquetas
- ❤️ **Sistema de favoritos** con almacenamiento local
- 📱 **Diseño responsivo** para móviles y escritorio
- 🔗 **Parámetros URL** para compartir filtros específicos
- 📥 **Descarga de imágenes** directamente desde la galería
- 🏷️ **Sistema de etiquetas** con conteo de imágenes

## Filtros Disponibles

- **Fechas**: Filtrar por rango de fechas
- **Fotógrafo**: Seleccionar fotógrafo específico
- **Etiquetas**: Filtrar por etiquetas con conteo de imágenes
- **Favoritos**: Mostrar solo imágenes marcadas como favoritas
- **Paginación**: Configurable (50, 100, 200, 500, 1000, 2000, 5000 imágenes por página)

## Parámetros URL

La aplicación soporta parámetros URL para inicializar filtros:

```
?page=1&perPage=1000&dateFrom=2024-01-01&dateTo=2024-01-31&photographer=email@ejemplo.com&tags=etiqueta&favorites=true
```

### Parámetros disponibles:
- `page`: Número de página (por defecto: 1)
- `perPage`: Imágenes por página (por defecto: 1000)
- `dateFrom`: Fecha desde (formato: YYYY-MM-DD)
- `dateTo`: Fecha hasta (formato: YYYY-MM-DD)
- `photographer`: Email del fotógrafo
- `tags`: Etiqueta específica
- `favorites`: Mostrar solo favoritos (valor: true)

## Ejemplos de URLs

### Filtrar por fechas específicas
```
fotiar.html?dateFrom=2024-01-01&dateTo=2024-01-31
```

### Filtrar por fotógrafo específico
```
fotiar.html?photographer=fotografo@ejemplo.com
```

### Filtrar por etiqueta específica
```
fotiar.html?tags=naturaleza
```

### Mostrar solo favoritos
```
fotiar.html?favorites=true
```

### Combinación de filtros
```
fotiar.html?dateFrom=2024-01-01&dateTo=2024-01-31&photographer=fotografo@ejemplo.com&tags=naturaleza
```

## Tecnologías Utilizadas

- **HTML5** con estructura semántica
- **CSS3** con Grid y Flexbox para layout responsivo
- **JavaScript ES6+** para funcionalidad interactiva
- **GitHub Pages** para hosting estático
- **GitHub Actions** para deploy automático

## Instalación y Uso

1. Clona el repositorio:
```bash
git clone https://github.com/tu-usuario/fotiar.git
cd fotiar
```

2. Abre `fotiar.html` en tu navegador web

3. O visita la página desplegada en GitHub Pages

## API

La aplicación se conecta a la API de Fotiar:
- **Endpoint**: `https://api1.foti.ar/images/search/client`
- **Método**: POST
- **Autenticación**: No requerida para visualización

## Contribuir

1. Fork el proyecto
2. Crea una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

## Licencia

Este proyecto está bajo la Licencia MIT. Ver el archivo `LICENSE` para más detalles.

## Contacto

- **Proyecto**: [Fotiar](https://github.com/tu-usuario/fotiar)
- **Email**: info@foti.ar
# cerro
