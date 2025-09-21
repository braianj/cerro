# Instrucciones para Deploy en GitHub Pages

## Configuración Inicial

1. **Crear repositorio en GitHub**:

   - Ve a GitHub y crea un nuevo repositorio
   - Nómbralo como `cerro` o el nombre que prefieras
   - Hazlo público para usar GitHub Pages gratis

2. **Subir archivos**:

   ```bash
   git init
   git add .
   git commit -m "Initial commit"
   git branch -M main
   git remote add origin https://github.com/TU-USUARIO/cerro.git
   git push -u origin main
   ```

3. **Configurar GitHub Pages**:
   - Ve a Settings > Pages en tu repositorio
   - En "Source", selecciona "GitHub Actions"
   - El workflow se ejecutará automáticamente

## Deploy Automático

El workflow `.github/workflows/deploy.yml` se ejecutará automáticamente cuando:

- Hagas push a la rama `main` o `master`
- Crear un pull request

## URL de la Página

Una vez configurado, tu galería estará disponible en:

```
https://TU-USUARIO.github.io/cerro/
```

o

```
https://TU-USUARIO.github.io/cerro/index.html
```

## Personalización

Para cambiar la URL base, modifica el archivo `index.html` y actualiza las rutas si es necesario.

## Troubleshooting

- Si el deploy falla, revisa los logs en Actions
- Asegúrate de que el repositorio sea público
- Verifica que GitHub Pages esté habilitado en Settings
