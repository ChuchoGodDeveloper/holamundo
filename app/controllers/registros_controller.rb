class RegistrosController < ApplicationController
  def new
    # Preparamos un formulario vacío
    @registro = Registro.new
  end

  def create
    @registro = Registro.new(registro_params)

    # Usamos .save para intentar guardar en la Base de Datos
    if @registro.save
      # Guardamos el ID del registro recién creado para buscarlo después
      flash[:registro_id] = @registro.id
      flash[:mensaje_exito] = "¡Guardado en Base de Datos con éxito!"
      
      redirect_to inicio_path
    else
      render :new, status: :unprocessable_entity
    end
  end
  
  # Filtro de seguridad para recibir los datos
  private
  
  def registro_params
    # Fíjate en el cambio: fotos: [] (con corchetes)
    if params[:registro].present?
      params.require(:registro).permit(:nombre, :apellido, :fecha_nacimiento, :localidad, :email, :telefono, fotos: [])
    else
      params.permit(:nombre, :apellido, :fecha_nacimiento, :localidad, :email, :telefono, fotos: [])
    end
  end
end