package com.noljanolja.shared

import com.rickclephas.kmp.nativecoroutines.NativeCoroutines
import io.ktor.client.*
import io.ktor.client.engine.*
import io.ktor.client.plugins.websocket.*
import io.rsocket.kotlin.ExperimentalMetadataApi
import io.rsocket.kotlin.core.RSocketConnector
import io.rsocket.kotlin.core.WellKnownMimeType
import io.rsocket.kotlin.keepalive.KeepAlive
import io.rsocket.kotlin.ktor.client.RSocketSupport
import io.rsocket.kotlin.ktor.client.rSocket
import io.rsocket.kotlin.metadata.CompositeMetadata
import io.rsocket.kotlin.metadata.RoutingMetadata
import io.rsocket.kotlin.metadata.metadata
import io.rsocket.kotlin.metadata.security.BearerAuthMetadata
import io.rsocket.kotlin.payload.PayloadMimeType
import io.rsocket.kotlin.payload.buildPayload
import io.rsocket.kotlin.payload.data
import kotlinx.coroutines.flow.*

@OptIn(ExperimentalMetadataApi::class)
class ConversationSocket(
    private val rsocketUrl: String,
    private val authRepo: AuthRepo,
) {
    private val socketClient: HttpClient = defaultRSocketClient()

    @NativeCoroutines
    fun streamConversations(): Flow<String> = flow {
        socketClient
            .rSocket(rsocketUrl)
            .requestStream(
                buildPayload {
                    data("""{ "data": "hello world" }""")
                    metadata(
                        CompositeMetadata(
                            RoutingMetadata("v1/conversations"),
                            BearerAuthMetadata("Bearer ${authRepo.getAuthToken()}")
                        )
                    )
                }
            )
            .map { it.data.readText() }
            .onEach { emit(it) }
            .collect()
    }
}

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
        }
    }
}

internal expect fun httpClientEngine(): HttpClientEngine
