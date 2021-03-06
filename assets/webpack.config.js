const path = require("path");
const glob = require("glob");
const MiniCssExtractPlugin = require("mini-css-extract-plugin");
const TerserPlugin = require("terser-webpack-plugin");
const OptimizeCSSAssetsPlugin = require("optimize-css-assets-webpack-plugin");
const CopyWebpackPlugin = require("copy-webpack-plugin");
const MonacoWebpackPlugin = require("monaco-editor-webpack-plugin");

module.exports = (env, options) => {
    const devMode = options.mode !== "production";

    return {
        optimization: {
            minimizer: [
                new TerserPlugin({
                    parallel: true,
                }),
                new OptimizeCSSAssetsPlugin({}),
            ],
        },
        entry: {
            app: glob.sync("./vendor/**/*.js").concat(["./js/app.js"]),
        },
        output: {
            filename: "[name].js",
            path: path.resolve(__dirname, "../priv/static/js"),
            publicPath: "/js/",
        },
        devtool: devMode ? "source-map" : undefined,
        module: {
            rules: [{
                    test: /\.js$/,
                    exclude: /node_modules/,
                    use: {
                        loader: "babel-loader",
                    },
                },
                {
                    test: /\.[s]?css$/,
                    use: [
                        MiniCssExtractPlugin.loader,
                        "css-loader",
                        "postcss-loader",
                    ],
                },
                {
                    test: /\.ttf$/,
                    use: ["file-loader"],
                },
            ],
        },
        plugins: [
            new MiniCssExtractPlugin({
                filename: "../css/app.css",
            }),
            new CopyWebpackPlugin({
                "patterns": [{
                    from: "static/",
                    to: "../",
                }, ]
            }),
            new MonacoWebpackPlugin({
                languages: ["markdown"],
            }),
        ],
    };
};