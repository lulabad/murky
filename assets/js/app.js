// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import "../css/app.css";
import Prism from "prismjs";
import * as monaco from "monaco-editor";
// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import deps with the dep name or local files with a relative path, for example:
//
//     import {Socket} from "phoenix"
//     import socket from "./socket"
//
import "phoenix_html";
import {
    Socket
} from "phoenix";
import NProgress from "nprogress";
import {
    LiveSocket
} from "phoenix_live_view";
import {
    PhoenixLiveViewDropzone
} from "phoenix_live_view_drop_zone";

const Hooks = {};
Hooks.MonacoEditor = {
    mounted() {
        this.edit = monaco.editor.create(this.el, {
            value: this.el.dataset.raw,
            language: "markdown",
            automaticLayout: true
        });
        this.edit.getModel().onDidChangeContent((e) =>
            this.pushEvent("update", {
                value: this.edit.getModel().getValue(),
            })
        );
        this.handleEvent("uploaded", ({
            image_link_md
        }) => this.edit.trigger('keyboard', 'type', {
            text: image_link_md
        }));
    },
};

Hooks.PhoenixLiveViewDropzone = new PhoenixLiveViewDropzone();


let csrfToken = document
    .querySelector("meta[name='csrf-token']")
    .getAttribute("content");
let liveSocket = new LiveSocket("/live", Socket, {
    params: {
        _csrf_token: csrfToken
    },
    hooks: Hooks,
});

// Show progress bar on live navigation and form submits
window.addEventListener("phx:page-loading-start", (info) => NProgress.start());
window.addEventListener("phx:page-loading-stop", (info) => NProgress.done());
window.addEventListener("phx:page-loading-stop", (info) => {
    Prism.highlightAll();
    console.log(info);
});

// connect if there are any LiveViews on the page
liveSocket.connect();

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)
window.liveSocket = liveSocket;