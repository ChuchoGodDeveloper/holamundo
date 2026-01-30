class CorregirTiposSolidQueue < ActiveRecord::Migration[8.0]
  def change
    # Cambiamos las columnas de Integer a Datetime (Fecha y Hora)
    change_column :solid_queue_jobs, :scheduled_at, :datetime
    change_column :solid_queue_jobs, :finished_at, :datetime
    
    change_column :solid_queue_scheduled_executions, :scheduled_at, :datetime
    
    change_column :solid_queue_blocked_executions, :expires_at, :datetime
    
    change_column :solid_queue_semaphores, :expires_at, :datetime
  end
end