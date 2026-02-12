class WelcomeController < ApplicationController
  def index
    # 1. PREGUNTAMOS: ¿Hay un ID guardado en la memoria (session)?
    if session[:registro_id]
      
      # 2. SI HAY, BUSCAMOS AL USUARIO EN LA BASE DE DATOS
      @registro = Registro.find_by(id: session[:registro_id])
      
      # (Si por alguna razón no lo encuentra, @registro será nil y mostrará el botón)
    end
  end
end