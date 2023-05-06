package com.noljanolja.shared

import io.ktor.client.*
import io.ktor.client.engine.*
import io.ktor.client.plugins.websocket.*
import io.rsocket.kotlin.RSocketLoggingApi
import io.rsocket.kotlin.core.RSocketConnector
import io.rsocket.kotlin.core.WellKnownMimeType
import io.rsocket.kotlin.keepalive.KeepAlive
import io.rsocket.kotlin.ktor.client.RSocketSupport
import io.rsocket.kotlin.logging.LoggingLevel
import io.rsocket.kotlin.logging.PrintLogger
import io.rsocket.kotlin.payload.PayloadMimeType
import io.rsocket.kotlin.payload.buildPayload
import io.rsocket.kotlin.payload.data

abstract class BaseSocket(
    protected val rsocketUrl: String,
    protected val authRepo: AuthRepo,
) {
    protected val socketClient: HttpClient = defaultRSocketClient()
}

@OptIn(RSocketLoggingApi::class)
private fun defaultRSocketClient() = HttpClient(httpClientEngine()) {
    install(WebSockets)
    install(RSocketSupport) {
        connector = RSocketConnector {
            connectionConfig {
                keepAlive = KeepAlive(30 * 1000, 120 * 1000)
                payloadMimeType = PayloadMimeType(
                    data = WellKnownMimeType.ApplicationJson,
                    metadata = WellKnownMimeType.MessageRSocketCompositeMetadata
                )
                setupPayload {
                    buildPayload {
                        data("""{ "data": "setup" }""")
                    }
                }
            }
            reconnectable { _, attempt -> attempt <= 3 }
            loggerFactory = PrintLogger.withLevel(LoggingLevel.DEBUG)
        }
    }
}

internal expect fun httpClientEngine(): HttpClientEngine
