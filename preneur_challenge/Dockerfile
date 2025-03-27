# Etapa de construcción (build stage)
FROM hexpm/elixir:1.13.4-erlang-24.2.1-alpine-3.16 AS build

# Establece el entorno de compilación en producción
ENV MIX_ENV=prod

# Instala dependencias necesarias para compilar (build-base, npm, git)
RUN apk add --no-cache build-base npm git

WORKDIR /app

# Copia los archivos de configuración de Elixir para aprovechar la caché de dependencias
COPY mix.exs mix.lock ./
COPY config config

# Obtiene y compila las dependencias en modo producción
RUN mix do deps.get --only prod, deps.compile

# Copia el resto del código de la aplicación
COPY lib lib
COPY priv priv
COPY assets assets

# Compila los assets (asegúrate de tener configurado esbuild y tailwind en tu proyecto)
RUN cd assets && npm install && cd ..
RUN mix phx.digest

# Compila la aplicación
RUN mix compile

# Crea la release de la aplicación
RUN mix release

# Etapa de ejecución (runtime stage)
FROM alpine:3.16 AS app

# Instala dependencias de runtime (libstdc++, openssl, ncurses)
RUN apk add --no-cache libstdc++ openssl ncurses-libs

# Establece el entorno en producción y define el puerto
ENV MIX_ENV=prod
ENV PORT=4000

WORKDIR /app

# Copia la release generada desde la etapa de build
COPY --from=build /app/_build/prod/rel/preneur_challenge ./

# Expone el puerto de la aplicación
EXPOSE 4000

# Comando para iniciar la aplicación
CMD ["bin/preneur_challenge", "start"]
