Rails.application.routes.draw do
  # 1. ESTO HACE QUE ARRANQUE EN EL CAPTCHA (Login)
  root "sessions#new"

  # 2. Rutas para el Login y Captcha
  post '/login', to: 'sessions#create'

  # 3. Ruta para tu pantalla final (Hola Mundo + Ticket)
  # Le ponemos el nombre 'inicio' para poder llamarla después
  get 'inicio', to: 'welcome#index', as: 'inicio'

  # 4. Rutas para el Formulario de Registro
  get 'registro', to: 'registros#new', as: 'new_registro'
  post 'registros', to: 'registros#create' # Acción estándar REST
end