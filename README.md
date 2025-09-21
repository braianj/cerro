# Galería de Imágenes Cerro

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
index.html?page=1&perPage=1000&dateFrom=2024-01-01&dateTo=2024-01-31&photographer=email@ejemplo.com&tags=etiqueta&favorites=true
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
index.html?dateFrom=2024-01-01&dateTo=2024-01-31
```

### Filtrar por fotógrafo específico

```
index.html?photographer=fotografo@ejemplo.com
```

### Filtrar por etiqueta específica

```
index.html?tags=naturaleza
```

### Mostrar solo favoritos

```
index.html?favorites=true
```

### Combinación de filtros

```
index.html?dateFrom=2024-01-01&dateTo=2024-01-31&photographer=fotografo@ejemplo.com&tags=naturaleza
```

# cerro
