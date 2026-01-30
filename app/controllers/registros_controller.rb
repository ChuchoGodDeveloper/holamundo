class RegistrosController < ApplicationController
  # Este callback busca el registro por ID antes de ejecutar show, edit o update
  before_action :set_registro, only: %i[ show edit update destroy ]

  # GET /registros
  def index
    @registros = Registro.all
  end

  # GET /registros/1
  def show
    # Rails busca automáticamente la vista 'show.html.erb'
  end

  # GET /registros/new
  def new
    @registro = Registro.new
  end

  # GET /registros/1/edit
  def edit
    # Rails busca automáticamente la vista 'edit.html.erb'
    # La variable @registro ya está definida por el before_action
  end

  # POST /registros
  def create
    @registro = Registro.new(registro_params)

    if @registro.save
      # Al crear, redirigimos al detalle del registro para que vean lo que guardaron
      flash[:mensaje_exito] = "¡Registro creado! Puedes agregar más fotos editándolo."
      redirect_to @registro
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /registros/1
  def update
    # 1. Capturamos la foto nueva aparte (si el usuario subió una)
    nueva_foto = registro_params[:fotos]

    # 2. Preparamos los datos a actualizar SIN la foto (para no sobreescribir las viejas todavía)
    parametros_sin_foto = registro_params.except(:fotos)

    if @registro.update(parametros_sin_foto)
      # 3. TRUCO: Si hay una foto nueva, la ADJUNTAMOS a la colección existente
      if nueva_foto.present?
        @registro.fotos.attach(nueva_foto)
      end

      redirect_to @registro, notice: "Registro actualizado correctamente."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /registros/1
  def destroy
    @registro.destroy
    redirect_to root_path, notice: "El registro fue eliminado."
  end

  private

  # Método para buscar el registro por ID (usado en el before_action)
  def set_registro
    @registro = Registro.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: "Registro no encontrado."
  end

  # Filtro de seguridad (Strong Parameters)
  def registro_params
    # CORRECCIÓN: Quitamos los corchetes [] de 'fotos' porque ahora subimos una por una.
    params.require(:registro).permit(:nombre, :apellido, :fecha_nacimiento, :localidad, :email, :telefono, :fotos)
  end
end