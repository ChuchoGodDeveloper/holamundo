Rails.application.routes.draw do
  # 1. ESTO HACE QUE ARRANQUE EN EL CAPTCHA (Login)
  root "sessions#new"

  # 2. Rutas para el Login y Captcha
  post '/login', to: 'sessions#create'

  # 3. Ruta para tu pantalla final (Hola Mundo + Ticket)
  get 'inicio', to: 'welcome#index', as: 'inicio'

  # 4. SOLUCIÓN MÁGICA:
  # 'resources' crea automáticamente la ruta 'show' (para ver el perfil)
  # y 'update' (para subir las fotos después). Esto arregla tu error 500.
  resources :registros
end