import Config

config :preneur_challenge, PreneurChallengeWeb.Endpoint,
  # La URL de la aplicación en producción.
  url: [host: System.get_env("PHX_HOST") || "jereprograma.com", port: 80],
  # Configuración HTTP: se toma el puerto desde la variable de entorno o se usa 4000 por defecto.
  http: [port: String.to_integer(System.get_env("PORT") || "4000")],
  # La clave secreta se obtiene de la variable de entorno (se debe generar con mix phx.gen.secret)
  secret_key_base: System.fetch_env!("SECRET_KEY_BASE"),
  # Cache del manifest de archivos estáticos, generado en assets.deploy.
  cache_static_manifest: "priv/static/cache_manifest.json",
  # Se activa el servidor en producción.
  server: true

# Configura el cliente API de Swoosh para enviar emails (no se usa almacenamiento local en producción).
config :swoosh, api_client: Swoosh.ApiClient.Finch, finch_name: PreneurChallenge.Finch
config :swoosh, local: false

# No se muestran mensajes de debug en producción.
config :logger, level: :info

# La configuración en tiempo de ejecución (por ejemplo, la base de datos, etc.) se realiza en config/runtime.exs.
