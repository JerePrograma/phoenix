import Config

# Configura la base de datos para el entorno de desarrollo
config :preneur_challenge, PreneurChallenge.Repo,
  username: "postgres",
  password: "root",
  hostname: "localhost",
  database: "preneur_challenge_dev",
  stacktrace: true,
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

# Para desarrollo, se deshabilita la caché y se habilita la recarga de código y la depuración.
# La configuración de watchers permite ejecutar herramientas externas para compilar assets.
# Al usar la dirección loopback, se evita el acceso desde otras máquinas.
config :preneur_challenge, PreneurChallengeWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4000],
  check_origin: false,
  code_reloader: true,
  debug_errors: true,
  secret_key_base: "5naW5oK+21gqyvmEpvpCjwYCAndXA2w6a0zuDz0WKONYOQI+nOMbrT/AYlG73g7b",
  watchers: [
    esbuild: {Esbuild, :install_and_run, [:preneur_challenge, ~w(--sourcemap=inline --watch)]},
    tailwind: {Tailwind, :install_and_run, [:preneur_challenge, ~w(--watch)]}
  ]

# Recarga en vivo de archivos estáticos y plantillas
config :preneur_challenge, PreneurChallengeWeb.Endpoint,
  live_reload: [
    patterns: [
      ~r"priv/static/(?!uploads/).*(js|css|png|jpeg|jpg|gif|svg)$",
      ~r"priv/gettext/.*(po)$",
      ~r"lib/preneur_challenge_web/(controllers|live|components)/.*(ex|heex)$"
    ]
  ]

# Habilita rutas de desarrollo para dashboard y buzón
config :preneur_challenge, dev_routes: true

# Configuración del Logger en desarrollo (sin metadatos ni timestamps)
config :logger, :console, format: "[$level] $message\n"

# Configura un stacktrace más profundo durante el desarrollo
config :phoenix, :stacktrace_depth, 20

# Inicializa los plugs en tiempo de ejecución para una compilación más rápida
config :phoenix, :plug_init_mode, :runtime

# Configuración adicional para Phoenix LiveView en desarrollo
config :phoenix_live_view,
  debug_heex_annotations: true,
  enable_expensive_runtime_checks: true

# Deshabilita el cliente API de Swoosh, ya que solo es requerido para adaptadores en producción.
config :swoosh, :api_client, false
