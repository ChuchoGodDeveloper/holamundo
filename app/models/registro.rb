class Registro < ApplicationRecord
  # Asocia las fotos (Active Storage)
  has_many_attached :fotos

  # --- VALIDACIONES DE TEXTO ---
  # El 'maximum' aquí asegura que el servidor proteja el límite de caracteres
  validates :nombre, presence: { message: "no puede estar vacío" }, 
            length: { maximum: 50 }, 
            format: { with: /\A[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]+\z/, message: "solo permite letras" }

  validates :apellido, presence: { message: "no puede estar vacío" }, 
            length: { maximum: 50 }, 
            format: { with: /\A[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]+\z/, message: "solo permite letras" }

  validates :localidad, presence: { message: "no puede estar vacía" }, 
            length: { maximum: 100 }

  validates :email, presence: { message: "no puede estar vacío" }, 
            format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i, message: "no es un correo válido" }

  validates :telefono, presence: { message: "no puede estar vacío" }, 
            numericality: { only_integer: true, message: "solo números" }, 
            length: { maximum: 10, message: "máximo 10 dígitos" }

  # --- VALIDACIONES DE FECHA ---
  validates :fecha_nacimiento, presence: { message: "no puede estar vacía" }
  validate :validar_edad_y_coherencia

  # --- VALIDACIONES DE FOTOS ---
  validate :validar_formato_imagenes

  private

  # 1. Lógica para mayores de 10 años y fechas lógicas
  def validar_edad_y_coherencia
    return if fecha_nacimiento.blank?

    # No nacer en el futuro
    if fecha_nacimiento > Date.today
      errors.add(:fecha_nacimiento, "no puede estar en el futuro")
    
    # Debe tener al menos 10 años (Nació ANTES de hace 10 años)
    elsif fecha_nacimiento > 10.years.ago.to_date
      errors.add(:fecha_nacimiento, "debes tener al menos 10 años para registrarte")
    
    # Coherencia: Que no tenga más de 100 años (ajustable)
    elsif fecha_nacimiento < 100.years.ago.to_date
      errors.add(:fecha_nacimiento, "año de nacimiento no válido (demasiado antiguo)")
    end
  end

  # 2. Validación solo de formato (permitimos guardar 1, 2 o 3 fotos)
  def validar_formato_imagenes
    return unless fotos.attached? # Si no hay fotos, no valida nada (permite guardar sin fotos al inicio)

    fotos.each do |foto|
      unless foto.content_type.in?(%w(image/jpeg image/png image/jpg))
        errors.add(:fotos, 'solo se permiten archivos JPG o PNG')
      end
    end
  end
end