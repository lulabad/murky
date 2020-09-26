module.exports = {
    purge: [
        "../**/*.html.eex",
        "../**/*.html.leex",
        "../**/views/**/*.ex",
        "../**/live/**/*.ex",
        "../**/live/components/**/*.ex",
        "./js/**/*.js",
    ],
    theme: {
        fontFamily: {
            sans: ['"Exo 2"'],
        },

        extend: {
            colors: {
                primary: {
                    100: "#336767",
                    200: "#739595",
                    300: "#4E7C7C",
                    400: "#205454",
                    500: "#0F4141",
                    600: "#092A2A",
                },
                secondary: {
                    100: "#3F4F73",
                    200: "#858FA7",
                    300: "#5C6A8A",
                    400: "#29395E",
                    500: "#162648",
                },
                alternate: {
                    100: "#448944",
                    200: "#9AC79A",
                    300: "#68A568",
                    400: "#2A702A",
                    500: "#145614",
                },
            },
        },
    },
    variants: {},
    plugins: [],
};