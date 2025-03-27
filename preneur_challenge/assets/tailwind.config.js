const plugin = require("tailwindcss/plugin");
const fs = require("fs");
const path = require("path");

module.exports = {
  content: [
    "./js/**/*.js",
    "../lib/preneur_challenge_web.ex",
    "../lib/preneur_challenge_web/**/*.{ex,heex}",
  ],
  theme: {
    extend: {
      colors: {
        brand: "#FD4F00",
        threads: {
          black: "#000000",
          white: "#ffffff",
          gray: {
            800: "#1a1a1a",
            900: "#121212",
            700: "#2a2a2a",
            500: "#71767b",
          },
        },
      },
      fontFamily: {
        // Si deseas agregar fuentes personalizadas para títulos o cuerpo
        heading: ['"Inter"', "sans-serif"],
        body: ['"Roboto"', "sans-serif"],
      },
      borderRadius: {
        threads: "9999px",
      },
      spacing: {
        "threads-sidebar": "4rem",
        "threads-sidebar-md": "5rem",
      },
      boxShadow: {
        threads: "0 4px 12px rgba(0, 0, 0, 0.15)",
      },
      keyframes: {
        fadeIn: {
          "0%": { opacity: "0", transform: "scale(0.95)" },
          "100%": { opacity: "1", transform: "scale(1)" },
        },
        fadeOut: {
          "0%": { opacity: "1", transform: "scale(1)" },
          "100%": { opacity: "0", transform: "scale(0.95)" },
        },
      },
      animation: {
        fadeIn: "fadeIn 0.3s ease-out forwards",
        fadeOut: "fadeOut 0.3s ease-out forwards",
      },
    },
  },
  plugins: [
    require("@tailwindcss/forms"),
    plugin(({ addVariant }) => {
      addVariant("phx-click-loading", [
        ".phx-click-loading&",
        ".phx-click-loading &",
      ]);
    }),
    plugin(({ addVariant }) => {
      addVariant("phx-submit-loading", [
        ".phx-submit-loading&",
        ".phx-submit-loading &",
      ]);
    }),
    plugin(({ addVariant }) => {
      addVariant("phx-change-loading", [
        ".phx-change-loading&",
        ".phx-change-loading &",
      ]);
    }),
    // Plugin para incluir íconos de Heroicons en tu CSS
    plugin(function ({ matchComponents, theme }) {
      const iconsDir = path.join(__dirname, "../deps/heroicons/optimized");
      const values = {};
      const icons = [
        ["", "/24/outline"],
        ["-solid", "/24/solid"],
        ["-mini", "/20/solid"],
        ["-micro", "/16/solid"],
      ];
      icons.forEach(([suffix, dir]) => {
        fs.readdirSync(path.join(iconsDir, dir)).forEach((file) => {
          const name = path.basename(file, ".svg") + suffix;
          values[name] = { name, fullPath: path.join(iconsDir, dir, file) };
        });
      });
      matchComponents(
        {
          hero: ({ name, fullPath }) => {
            let content = fs
              .readFileSync(fullPath)
              .toString()
              .replace(/\r?\n|\r/g, "");
            let size = theme("spacing.6");
            if (name.endsWith("-mini")) size = theme("spacing.5");
            else if (name.endsWith("-micro")) size = theme("spacing.4");
            return {
              [`--hero-${name}`]: `url('data:image/svg+xml;utf8,${content}')`,
              "-webkit-mask": `var(--hero-${name})`,
              mask: `var(--hero-${name})`,
              "mask-repeat": "no-repeat",
              "background-color": "currentColor",
              "vertical-align": "middle",
              display: "inline-block",
              width: size,
              height: size,
            };
          },
        },
        { values }
      );
    }),
    // Plugin personalizado para agregar componentes específicos para Threads
    plugin(function ({ addComponents, theme }) {
      const threadsComponents = {
        ".threads-container": {
          minHeight: "100vh",
          backgroundColor: theme("colors.threads.black"),
          color: theme("colors.threads.white"),
        },
        ".threads-header": {
          position: "sticky",
          top: "0",
          zIndex: "10",
          display: "flex",
          alignItems: "center",
          justifyContent: "space-between",
          padding: "1rem",
          backgroundColor: theme("colors.threads.black"),
          borderBottom: `1px solid ${theme("colors.threads.gray.800")}`,
        },
        ".threads-button": {
          borderRadius: theme("borderRadius.threads"),
          padding: "0.5rem 1rem",
          fontWeight: "500",
          transition: "background-color 0.2s",
        },
        ".threads-primary-button": {
          backgroundColor: theme("colors.threads.white"),
          color: theme("colors.threads.black"),
          "&:hover": {
            backgroundColor: "#e5e5e5",
          },
        },
        ".threads-secondary-button": {
          backgroundColor: "transparent",
          color: theme("colors.threads.white"),
          border: `1px solid ${theme("colors.threads.gray.700")}`,
          "&:hover": {
            backgroundColor: theme("colors.threads.gray.900"),
          },
        },
        ".threads-modal": {
          position: "fixed",
          inset: "0",
          zIndex: "50",
          display: "flex",
          alignItems: "center",
          justifyContent: "center",
          backgroundColor: "rgba(0, 0, 0, 0.7)",
        },
        ".threads-modal-content": {
          width: "100%",
          maxWidth: "32rem",
          backgroundColor: theme("colors.threads.black"),
          border: `1px solid ${theme("colors.threads.gray.800")}`,
          borderRadius: "0.75rem",
          boxShadow: theme("boxShadow.threads"),
        },
        ".threads-modal-header": {
          display: "flex",
          alignItems: "center",
          justifyContent: "space-between",
          padding: "1rem",
          borderBottom: `1px solid ${theme("colors.threads.gray.800")}`,
        },
        ".threads-textarea": {
          width: "100%",
          backgroundColor: "transparent",
          border: "none",
          color: theme("colors.threads.white"),
          resize: "none",
          padding: "1rem",
          "&::placeholder": {
            color: theme("colors.threads.gray.500"),
          },
        },
        ".threads-avatar": {
          width: "2.5rem",
          height: "2.5rem",
          borderRadius: theme("borderRadius.threads"),
          objectFit: "cover",
        },
        ".threads-sidebar": {
          position: "fixed",
          left: "0",
          top: "0",
          height: "100%",
          width: theme("spacing.threads-sidebar"),
          borderRight: `1px solid ${theme("colors.threads.gray.800")}`,
          backgroundColor: theme("colors.threads.black"),
          display: "flex",
          flexDirection: "column",
          alignItems: "center",
          padding: "1.5rem 0",
          gap: "2rem",
          "@screen md": {
            width: theme("spacing.threads-sidebar-md"),
          },
        },
        ".threads-sidebar-icon": {
          padding: "0.5rem",
          borderRadius: theme("borderRadius.threads"),
          transition: "background-color 0.2s",
          "&:hover": {
            backgroundColor: theme("colors.threads.gray.800"),
          },
        },
        ".threads-post-list": {
          borderTop: `1px solid ${theme("colors.threads.gray.800")}`,
          "& > *": {
            borderBottom: `1px solid ${theme("colors.threads.gray.800")}`,
          },
        },
        ".threads-post": {
          padding: "1rem",
          "&:hover": {
            backgroundColor: "rgba(26, 26, 26, 0.5)",
          },
        },
      };

      addComponents(threadsComponents);
    }),
  ],
};
