# CFA-Token

**CFA-Token** is an experimental Cardano blockchain project focused on creating and minting a digital token intended to represent the Central African CFA franc (XAF).

The project combines **Haskell, Plutus V2, and TypeScript (Lucid)** to implement an on-chain minting policy and an off-chain transaction client for issuing tokens on the Cardano blockchain.

> **Project Status:** Experimental / Development. This repository contains an initial implementation of a token minting policy and a transaction client configured for the Cardano Preview test network. It has not been established as a production-ready stablecoin or audited financial application.

## Table of Contents

- [Overview](#overview)
- [Key Features](#key-features)
- [Architecture](#architecture)
- [Repository Structure](#repository-structure)
- [Technology Stack](#technology-stack)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Building the Project](#building-the-project)
- [Token Minting Workflow](#token-minting-workflow)
- [Security Considerations](#security-considerations)
- [Testing](#testing)
- [Known Limitations](#known-limitations)
- [Future Improvements](#future-improvements)
- [Contributing](#contributing)
- [License](#license)

## Overview

CFA-Token explores the implementation of a digital asset on the Cardano blockchain using Plutus smart contracts.

The current implementation focuses on two main components:

1. **On-chain minting policy:** A Plutus V2 smart contract written in Haskell that authorizes token minting only when a designated payment public key hash has signed the transaction.
2. **Off-chain transaction client:** A TypeScript application using Lucid and Blockfrost to construct, sign, and submit token minting transactions.

The token asset name used by the current implementation is `XAF-FCFA`.

The project also provides reusable Haskell utilities for working with Cardano and Plutus scripts, including serialization, hashing, address conversion, and transaction-related data transformations.

## Key Features

- **Cardano blockchain integration:** Built around Cardano's Extended UTXO architecture.
- **Plutus V2 minting policy:** Implements signature-based authorization for token issuance.
- **Controlled minting:** Requires authorization from a designated payment public key hash.
- **Lucid transaction integration:** Uses Lucid to construct and submit Cardano transactions.
- **Blockfrost connectivity:** Connects to the Cardano Preview network through the Blockfrost API.
- **Plutus script serialization:** Provides utilities for compiling and exporting Plutus scripts.
- **Cardano address and hash utilities:** Includes helper functions for address conversion, policy hashes, currency symbols, and related operations.

## Architecture

The project is organized into on-chain and off-chain components.

### 1. On-chain component (Haskell / Plutus V2)

The minting policy is implemented in:

`src/CFAMintingPolicy.hs`

Its main validation function is:

```haskell
mkCFAMintingPolicy
  :: PubKeyHash
  -> ()
  -> ScriptContext
  -> Bool
```

The policy verifies that the transaction has been signed by the configured public key hash.

If the required signature is missing, the transaction is rejected with the validation message:

```text
missing signature
```

The implementation also provides functions for:

- Compiling the minting policy.
- Applying the payment public key hash as a policy parameter.
- Generating the corresponding minting policy.
- Deriving the policy currency symbol.
- Exporting compiled Plutus scripts.

### 2. Off-chain component (TypeScript / Lucid)

The transaction implementation is located in:

`Lucid/CFAtransaction.ts`

It uses Lucid to interact with the Cardano Preview network.

The current workflow consists of:

1. Connecting to the Cardano Preview network through Blockfrost.
2. Selecting a wallet.
3. Retrieving the wallet address and payment credentials.
4. Defining the Plutus V2 minting policy.
5. Deriving the token policy ID.
6. Constructing the token asset identifier using the policy ID and `XAF-FCFA` asset name.
7. Building a transaction that mints the requested token quantity.
8. Attaching the minting policy and specifying the required signer.
9. Signing and submitting the transaction.
10. Displaying the transaction hash.

The minting client prompts the user to enter the amount to mint. If no amount is provided, the current implementation defaults to `1,000,000` asset units.

**Note:** The implementation handles token quantities as integer asset units. It does not implement fiat conversion, decimal normalization, or exchange-rate calculations.

## Repository Structure

```text
CFA-Token/
│
├── app/
│   └── Main.hs
│
├── assets/
│   ├── exo.hs
│   ├── script.addr
│   └── signed-*.plutus
│
├── src/
│   ├── CFAMintingPolicy.hs
│   └── MyLib.hs
│
├── Utilities/
│   ├── Utilities.cabal
│   └── src/
│       ├── Utilities.hs
│       └── Utilities/
│           ├── Conversions.hs
│           ├── PlutusTx.hs
│           └── Serialise.hs
│
├── Lucid/
│   ├── CFAtransaction.ts
│   └── seed.ts
│
├── test/
│   └── MyLibTest.hs
│
├── CFAToken.cabal
├── cabal.project
├── CHANGELOG.md
├── LICENSE
└── README.md
```

### Main Components

| File / Directory | Description |
|---|---|
| `src/CFAMintingPolicy.hs` | Implements the Plutus V2 token minting policy. |
| `Lucid/CFAtransaction.ts` | Handles token minting transaction construction and submission. |
| `Lucid/seed.ts` | Contains wallet seed configuration and string/hex conversion utilities. |
| `Utilities/Conversions.hs` | Provides Cardano and Plutus conversion utilities. |
| `Utilities/PlutusTx.hs` | Implements reusable Plutus validator and policy wrappers. |
| `Utilities/Serialise.hs` | Handles Plutus script serialization and JSON conversion. |
| `CFAToken.cabal` | Defines the Haskell package, dependencies, and build configuration. |
| `cabal.project` | Defines project dependencies and package repositories. |
| `assets/` | Stores generated scripts and related artifacts. |

## Technology Stack

The project uses the following technologies:

| Technology | Purpose |
|---|---|
| Cardano | Blockchain infrastructure |
| Plutus V2 | Smart contract and minting policy framework |
| Haskell | On-chain policy implementation |
| Cardano API | Blockchain data and script serialization |
| Cabal | Haskell build and dependency management |
| TypeScript | Off-chain transaction implementation |
| Deno | TypeScript runtime |
| Lucid 0.9.1 | Cardano transaction construction |
| Blockfrost | Cardano blockchain API access |

## Prerequisites

Before building or running the project, ensure that the following tools and resources are available:

- GHC (Glasgow Haskell Compiler).
- Cabal.
- Deno.
- Access to the Cardano Haskell Packages repository.
- A Blockfrost API key for the Cardano Preview network.
- A dedicated Cardano Preview wallet funded with test ADA.

**Compatibility note:** The project uses an older Cardano and Plutus dependency configuration. The versions specified in `cabal.project` should be respected when setting up the development environment.

## Installation

Clone the repository:

```bash
git clone https://github.com/angedid/CFA-Token.git
```

Navigate to the project directory:

```bash
cd CFA-Token
```

## Building the Project

Update the Cabal package index:

```bash
cabal update
```

Build the project:

```bash
cabal build all
```

Run the available tests:

```bash
cabal test all
```

The build and test commands use the package configuration defined in `CFAToken.cabal` and `cabal.project`.

## Token Minting Workflow

The off-chain minting implementation is located in:

```text
Lucid/CFAtransaction.ts
```

The current implementation uses the Cardano Preview network through the following Blockfrost endpoint:

```text
https://cardano-preview.blockfrost.io/api/v0
```

After configuring the client with valid credentials, the script can be executed using Deno:

```bash
deno run --allow-net Lucid/CFAtransaction.ts
```

The script prompts for the token quantity, constructs the minting transaction, signs it using the configured wallet, and submits it to the Cardano network.

The resulting transaction hash is printed to the console.

**Important:** The checked-in client currently contains exposed wallet and API credentials. Do not execute it as-is. Rotate the exposed credentials and replace the hard-coded configuration with secure environment-based configuration before running the application.

## Security Considerations

Security is particularly important for blockchain applications because wallet credentials provide direct control over digital assets.

The following measures are essential:

1. **Wallet security:** A recovery phrase is present in the repository's source code. Treat the associated wallet as compromised, generate a new wallet, and move any remaining funds or assets to a secure address.
2. **API key protection:** The Blockfrost API key is hard-coded in the transaction client. Revoke or rotate it.
3. **Environment configuration:** Store API keys and wallet credentials in environment variables or an appropriate secret-management service.
4. **Git history:** Removing credentials from the current source files does not remove them from previous commits. Review the repository history and address exposed secrets.
5. **Network isolation:** Use test networks during development and validation.
6. **Smart contract auditing:** Conduct an independent security review before deploying the minting policy for real-world use.

Never commit wallet recovery phrases, private keys, or API credentials to the repository.

## Testing

The repository currently includes a Cabal test suite under:

```text
test/MyLibTest.hs
```

However, the existing tests are minimal and do not constitute comprehensive validation of the token minting functionality.

Further testing should cover:

- Successful minting with the authorized signer.
- Rejection of transactions without the required signature.
- Correct minting policy parameterization.
- Correct derivation of policy IDs and asset identifiers.
- Minting quantity validation.
- Transaction construction and submission.
- Network and transaction failure handling.

Integration tests should also be performed on the Cardano Preview network.

## Known Limitations

The current implementation represents an initial token minting prototype. Several important features required for a production-ready digital currency are not yet implemented.

### 1. No fiat backing mechanism

The repository does not implement or demonstrate a reserve management system, collateral mechanism, or redemption process guaranteeing the value of the token against the Central African CFA franc.

### 2. No redemption or burning functionality

The visible transaction client focuses on token minting. A complete lifecycle would require mechanisms for token burning and redemption.

### 3. No maximum supply enforcement

The current minting policy checks the presence of an authorized signature. It does not independently enforce a maximum supply, issuance schedule, or broader monetary governance rules.

### 4. Preview network configuration

The existing transaction client is configured for Cardano Preview and should not be considered ready for mainnet deployment.

### 5. Incomplete application integration

The Haskell executable in `app/Main.hs` remains a basic scaffold. The main transaction workflow is implemented separately in the TypeScript client.

### 6. Limited test coverage

Additional unit, integration, and smart contract validation tests are required before production deployment.

## Future Improvements

Potential development directions include:

- Implementing token burning and redemption functionality.
- Introducing supply management and issuance controls.
- Implementing a complete token lifecycle.
- Adding comprehensive smart contract and integration tests.
- Improving wallet and API credential management.
- Adding transaction monitoring and reporting.
- Developing a user-friendly interface for token operations.
- Exploring reserve verification and mechanisms for maintaining the intended XAF peg.
- Preparing a secure and audited mainnet deployment process.

## Contributing

Contributions, suggestions, and improvements are welcome.

To contribute:

1. Fork the repository.
2. Create a feature branch.
3. Implement your changes.
4. Add relevant tests and documentation.
5. Submit a pull request describing your changes.

Please ensure that contributions do not introduce exposed credentials, private keys, or other sensitive information.

For substantial changes to the minting policy or token architecture, opening an issue before implementation is encouraged.

## License

This project is distributed under the **Apache License 2.0**.

See the [LICENSE](LICENSE) file for the complete license terms.

---

**Repository:** https://github.com/angedid/CFA-Token

**Project:** CFA-Token  
**Blockchain:** Cardano  
**Token Asset Name:** XAF-FCFA  
**Smart Contract Framework:** Plutus V2  
**Development Status:** Experimental

