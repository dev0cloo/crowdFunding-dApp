import React from "react";
import ReactDOM from "react-dom/client";
import App from "./App";
import { ChainId, ThirdwebProvider } from "@thirdweb-dev/react";
import { BrowserRouter as Router } from "react-router-dom";
import "./index.css";

// This is the chainId your dApp will work on.
const activeChainId = ChainId.Goerli;

const container = document.getElementById("root");
const root = ReactDOM.createRoot(container);
root.render(
  <ThirdwebProvider desiredChainId={activeChainId}>
    <Router>
      <App />
    </Router>
  </ThirdwebProvider>
);
