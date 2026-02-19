class Registro < ApplicationRecord
  # Asocia las fotos (Active Storage)
  has_many_attached :fotos

  # --- VALIDACIONES DE TEXTO ---
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
    
    # Debe tener al menos 10 años
    elsif fecha_nacimiento > 10.years.ago.to_date
      errors.add(:fecha_nacimiento, "debes tener al menos 10 años para registrarte")
    
    # Coherencia: Que no tenga más de 100 años
    elsif fecha_nacimiento < 100.years.ago.to_date
      errors.add(:fecha_nacimiento, "año de nacimiento no válido (demasiado antiguo)")
    end
  end

  # 2. Validación estricta de formato
  def validar_formato_imagenes
    return unless fotos.attached?

    # Lista blanca de formatos permitidos (MIME types)
    # Al usar esta lista, automáticamente se bloquean PDFs, Docs, EXE, etc.
    tipos_permitidos = %w[image/jpeg image/jpg image/png image/gif image/webp]

    fotos.each do |foto|
      unless tipos_permitidos.include?(foto.content_type)
        errors.add(:fotos, 'no válida. Solo se aceptan archivos de imagen (JPG, PNG, GIF, WEBP)')
      end
    end
  end
end