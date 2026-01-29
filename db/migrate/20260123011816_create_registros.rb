class CreateRegistros < ActiveRecord::Migration[8.1]
  def change
    create_table :registros do |t|
      t.string :nombre
      t.string :apellido
      t.date :fecha_nacimiento
      t.string :localidad
      t.string :email
      t.string :telefono

      t.timestamps
    end
  end
end
