package com.noljanolja.shared

import io.ktor.client.engine.*
import io.ktor.client.engine.darwin.*

internal actual fun httpClientEngine(): HttpClientEngine = Darwin.create()
