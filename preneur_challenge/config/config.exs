# config/config.exs
#
# Este archivo se encarga de configurar la aplicación y sus dependencias
# utilizando el módulo Config. Se carga antes de cualquier dependencia y
# está restringido a este proyecto.

import Config

# Configuración general de la aplicación
config :preneur_challenge,
  ecto_repos: [PreneurChallenge.Repo],
  generators: [timestamp_type: :utc_datetime]

# Configuración del endpoint de la aplicación
config :preneur_challenge, PreneurChallengeWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [html: PreneurChallengeWeb.ErrorHTML, json: PreneurChallengeWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: PreneurChallenge.PubSub,
  live_view: [signing_salt: "MxLgOJD9"]

# Configuración del mailer
#
# Se utiliza el adaptador "Local" por defecto para almacenar los correos de forma local.
# En producción se recomienda cambiar a un adaptador diferente configurado en `config/runtime.exs`.
config :preneur_challenge, PreneurChallenge.Mailer,
  adapter: Swoosh.Adapters.Local

# Configuración de esbuild
# Esbuild se usa para compilar los assets JavaScript y se requiere especificar la versión.
config :esbuild,
  version: "0.17.11",
  preneur_challenge: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configuración de Tailwind CSS
# Tailwind se encarga del procesamiento de los archivos CSS según la configuración dada.
config :tailwind,
  version: "3.4.3",
  preneur_challenge: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

# Configuración de Logger de Elixir
# Se define el formato de salida y los metadatos que se incluirán en los logs.
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Se indica a Phoenix que use Jason para el parseo de JSON
config :phoenix, :json_library, Jason

# Importa la configuración específica para cada entorno (dev, test, prod)
# Este import debe ir al final para que sobreescriba la configuración definida anteriormente.
import_config "#{config_env()}.exs"
