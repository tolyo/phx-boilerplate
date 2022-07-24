// Generated using webpack-cli https://github.com/webpack/webpack-cli
const MiniCssExtractPlugin = require("mini-css-extract-plugin");
const path = require("path");
const isProduction = process.env.NODE_ENV == "production";

const config = {
  entry: {
    app: "./lib/web/app.js",
    css: "./lib/web/app.css",
  },
  output: {
    path: path.resolve(__dirname, "dist"),
  },
  plugins: [
    // Add your plugins here
    // Learn more about plugins from https://webpack.js.org/configuration/plugins/
  ],
  module: {
    rules: [
      {
        test: /\.(js|jsx)$/i,
        loader: "babel-loader",
      },
      {
        test: /\.css$/i,
        use: [MiniCssExtractPlugin.loader, "css-loader", "postcss-loader"],
      },
      {
        test: /\.(eot|svg|ttf|woff|woff2|png|jpg|gif)$/i,
        type: "asset",
      },

      // Add your rules for custom modules here
      // Learn more about loaders from https://webpack.js.org/loaders/
    ],
  },
};

module.exports = () => {
  [new MiniCssExtractPlugin({ filename: "app.css" })].forEach((x) =>
    config.plugins.push(x)
  );
  if (isProduction) {
    config.mode = "production";

    //config.plugins.push();
  } else {
    config.mode = "development";
  }
  return config;
};
