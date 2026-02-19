# PATCH/PUT /registros/1
  def update
    # 1. Separamos la foto de los datos de texto
    nueva_foto = registro_params[:fotos]
    datos_sin_foto = registro_params.except(:fotos)

    # 2. Primero intentamos guardar los cambios de texto (Nombre, Teléfono, etc.)
    if @registro.update(datos_sin_foto)

      # CASO A: El usuario subió una foto nueva
      if nueva_foto.present?
        # Adjuntamos la foto temporalmente
        @registro.fotos.attach(nueva_foto)

        # 3. ¡VALIDACIÓN DE SEGURIDAD! 🛡️
        # Preguntamos al Modelo si todo está bien (incluyendo el formato de imagen)
        unless @registro.valid?
          # SI FALLA: Borramos inmediatamente el archivo inválido del servidor
          @registro.fotos.last.purge
          
          # Avisamos al usuario del error específico
          mensaje_error = @registro.errors.full_messages.join(", ")
          redirect_to inicio_path, alert: "❌ Error: #{mensaje_error}"
          return # Importante: Detenemos todo aquí
        end

        # SI PASA: Todo bien
        redirect_to inicio_path, notice: "✅ Evidencia agregada correctamente."

      # CASO B: Solo se actualizaron textos (desde el panel de admin)
      else
        redirect_to registros_path, notice: "Datos actualizados correctamente."
      end

    else
      # Si falló la validación de los datos de texto (ej: nombre vacío)
      render :edit, status: :unprocessable_entity
    end
  end