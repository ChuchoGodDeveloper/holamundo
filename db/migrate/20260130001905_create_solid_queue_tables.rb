class CreateSolidQueueTables < ActiveRecord::Migration[8.0]
  def change
    create_table :solid_queue_jobs do |t|
      t.string :queue_name, null: false
      t.string :class_name, null: false
      t.text :arguments
      t.integer :priority, default: 0, null: false
      t.string :active_job_id
      t.integer :scheduled_at
      t.integer :finished_at
      t.string :concurrency_key
      t.timestamps
    end

    add_index :solid_queue_jobs, [ :queue_name, :finished_at ], name: "index_solid_queue_jobs_for_filtering"
    add_index :solid_queue_jobs, [ :scheduled_at, :finished_at ], name: "index_solid_queue_jobs_for_alerting"

    create_table :solid_queue_scheduled_executions do |t|
      t.references :job, index: { unique: true }, null: false
      t.string :queue_name, null: false
      t.integer :priority, default: 0, null: false
      t.integer :scheduled_at, null: false
      t.timestamps
    end

    add_index :solid_queue_scheduled_executions, [ :scheduled_at, :priority, :job_id ], name: "index_solid_queue_dispatch_all"

    create_table :solid_queue_ready_executions do |t|
      t.references :job, index: { unique: true }, null: false
      t.string :queue_name, null: false
      t.integer :priority, default: 0, null: false
      t.timestamps
    end

    add_index :solid_queue_ready_executions, [ :priority, :job_id ], name: "index_solid_queue_poll_all"
    add_index :solid_queue_ready_executions, [ :queue_name, :priority, :job_id ], name: "index_solid_queue_poll_by_queue"

    create_table :solid_queue_claimed_executions do |t|
      t.references :job, index: { unique: true }, null: false
      t.bigint :process_id
      t.timestamp :created_at, null: false
    end

    add_index :solid_queue_claimed_executions, [ :process_id, :job_id ], name: "index_solid_queue_claimed_executions_on_process_id_and_job_id"

    create_table :solid_queue_blocked_executions do |t|
      t.references :job, index: { unique: true }, null: false
      t.string :queue_name, null: false
      t.integer :priority, default: 0, null: false
      t.string :concurrency_key, null: false
      t.integer :expires_at, null: false
      t.timestamps
    end

    add_index :solid_queue_blocked_executions, [ :expires_at, :concurrency_key ], name: "index_solid_queue_blocked_executions_for_release"
    add_index :solid_queue_blocked_executions, [ :concurrency_key, :priority, :job_id ], name: "index_solid_queue_blocked_executions_for_acquire"

    create_table :solid_queue_failed_executions do |t|
      t.references :job, index: { unique: true }, null: false
      t.text :error
      t.timestamps
    end

    create_table :solid_queue_pauses do |t|
      t.string :queue_name, null: false
      t.timestamp :created_at, null: false
    end

    add_index :solid_queue_pauses, :queue_name, unique: true

    create_table :solid_queue_processes do |t|
      t.string :kind, null: false
      t.datetime :last_heartbeat_at, null: false
      t.integer :supervisor_id
      t.integer :pid, null: false
      t.string :hostname
      t.text :metadata
      t.timestamp :created_at, null: false
    end

    add_index :solid_queue_processes, :last_heartbeat_at

    create_table :solid_queue_semaphores do |t|
      t.string :key, null: false
      t.integer :value, default: 1, null: false
      t.integer :expires_at, null: false
      t.timestamps
    end

    add_index :solid_queue_semaphores, [ :key, :value ], name: "index_solid_queue_semaphores_on_key_and_value"
    add_index :solid_queue_semaphores, :expires_at
  end
end