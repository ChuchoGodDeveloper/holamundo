class CorregirTiposSolidQueue < ActiveRecord::Migration[8.0]
  def change
    # Detectamos si estamos usando Postgres (Render) o SQLite (Local)
    es_postgres = connection.adapter_name.downcase.include?("postgres")

    columns = [
      [:solid_queue_jobs, :scheduled_at],
      [:solid_queue_jobs, :finished_at],
      [:solid_queue_scheduled_executions, :scheduled_at],
      [:solid_queue_blocked_executions, :expires_at],
      [:solid_queue_semaphores, :expires_at]
    ]

    columns.each do |table, column|
      if es_postgres
        # Comando para Render (Nube)
        change_column table, column, :datetime, using: "to_timestamp(#{column})"
      else
        # Comando para tu PC (Local)
        change_column table, column, :datetime
      end
    end
  end
end