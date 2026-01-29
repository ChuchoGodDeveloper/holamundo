class Registro < ApplicationRecord
  # CAMBIO 1: Ahora son "muchas" fotos
  has_many_attached :fotos

  # --- VALIDACIONES DE DATOS ---
  validates :nombre, presence: { message: "no puede estar vacío" }, length: { maximum: 70 }, format: { with: /\A[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]+\z/ }
  validates :apellido, presence: { message: "no puede estar vacío" }, length: { maximum: 70 }, format: { with: /\A[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]+\z/ }
  validates :fecha_nacimiento, presence: { message: "no puede estar vacía" }
  validate :la_fecha_debe_ser_valida_y_pasada
  validates :localidad, presence: { message: "no puede estar vacía" }, length: { maximum: 150 }
  validates :email, presence: { message: "no puede estar vacío" }, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }
  validates :telefono, presence: { message: "no puede estar vacío" }, numericality: { only_integer: true }, length: { maximum: 10 }

  # CAMBIO 2: Validación personalizada para contar las fotos
  validate :validar_tres_fotos

  private

  def validar_tres_fotos
    # Si no hay fotos adjuntas
    if !fotos.attached?
      errors.add(:fotos, "debes subir tus 3 imágenes de evidencia")
      return
    end

    # Si hay fotos, pero no son 3
    if fotos.count != 3
      errors.add(:fotos, "debes subir exactamente 3 imágenes (subiste #{fotos.count})")
    end

    # Validar formato de cada una
    fotos.each do |foto|
      unless foto.content_type.in?(%w(image/jpeg image/png image/jpg))
        errors.add(:fotos, 'solo se permiten archivos JPG o PNG')
      end
    end
  end

  def la_fecha_debe_ser_valida_y_pasada
    return if fecha_nacimiento.blank?
    if fecha_nacimiento > Date.today
       errors.add(:fecha_nacimiento, "no puede ser futura") 
    elsif fecha_nacimiento.year > 2025
       errors.add(:fecha_nacimiento, "no puede ser mayor al año 2025")
    end
  end
end