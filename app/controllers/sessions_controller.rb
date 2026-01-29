class SessionsController < ApplicationController
  def new
    # Esto solo muestra la pantalla de Login
  end

  def create
    # Aquí Rails verifica si el usuario resolvió el rompecabezas
    if verify_recaptcha
      # SI ES HUMANO: Lo mandamos al formulario de registro que creamos
      redirect_to new_registro_path, notice: "¡Verificación exitosa! Bienvenido."
    else
      # SI FALLA: Le mostramos error y volvemos a cargar la página
      flash.now[:alert] = "Error de verificación. Por favor demuestra que eres humano."
      render :new, status: :unprocessable_entity
    end
  end
end