class RegistrosController < ApplicationController
  # Solo necesitamos buscar el registro para actualizar la foto (update)
  before_action :set_registro, only: %i[ update ]

  # GET /registros/new
  def new
    @registro = Registro.new
  end

  # POST /registros
  def create
    @registro = Registro.new(registro_params)

    if @registro.save
      # 1. GUARDAMOS EL ID EN LA SESIÓN (Para que el Ticket sepa quién es)
      session[:registro_id] = @registro.id

      # 2. REDIRIGIMOS AL INICIO (Ticket) en lugar de al perfil
      # Esto soluciona el error "No template found"
      redirect_to inicio_path, notice: "Datos guardados. Ahora sube tu evidencia."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /registros/1
  def update
    # Lógica para subir fotos una por una DESDE EL INDEX
    nueva_foto = registro_params[:fotos]

    # Preparamos los datos sin la foto por seguridad
    parametros_sin_foto = registro_params.except(:fotos)

    if @registro.update(parametros_sin_foto)
      # Si subió una foto, la adjuntamos a las que ya tiene (sin borrar las anteriores)
      if nueva_foto.present?
        @registro.fotos.attach(nueva_foto)
      end

      # AL ACTUALIZAR, NOS QUEDAMOS EN EL INDEX (Ticket)
      redirect_to inicio_path, notice: "Evidencia agregada correctamente."
    else
      redirect_to inicio_path, alert: "Error al subir la foto."
    end
  end

  private

  def set_registro
    @registro = Registro.find(params[:id])
  end

  def registro_params
    # Permitimos datos normales y la foto (sin corchetes, porque es una por una)
    params.require(:registro).permit(:nombre, :apellido, :fecha_nacimiento, :localidad, :email, :telefono, :fotos)
  end
end