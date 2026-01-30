class CorregirTiposSolidQueue < ActiveRecord::Migration[8.0]
  def change
    # Ahora le decimos a Postgres explícitamente CÓMO convertir los datos usando 'to_timestamp'
    change_column :solid_queue_jobs, :scheduled_at, :datetime, using: 'to_timestamp(scheduled_at)'
    change_column :solid_queue_jobs, :finished_at, :datetime, using: 'to_timestamp(finished_at)'
    
    change_column :solid_queue_scheduled_executions, :scheduled_at, :datetime, using: 'to_timestamp(scheduled_at)'
    
    change_column :solid_queue_blocked_executions, :expires_at, :datetime, using: 'to_timestamp(expires_at)'
    
    change_column :solid_queue_semaphores, :expires_at, :datetime, using: 'to_timestamp(expires_at)'
  end
end