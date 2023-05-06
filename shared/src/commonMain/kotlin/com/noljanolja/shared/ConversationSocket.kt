package com.noljanolja.shared

import com.rickclephas.kmp.nativecoroutines.NativeCoroutines
import io.rsocket.kotlin.ExperimentalMetadataApi
import io.rsocket.kotlin.ktor.client.rSocket
import io.rsocket.kotlin.metadata.CompositeMetadata
import io.rsocket.kotlin.metadata.RoutingMetadata
import io.rsocket.kotlin.metadata.metadata
import io.rsocket.kotlin.metadata.security.BearerAuthMetadata
import io.rsocket.kotlin.payload.buildPayload
import io.rsocket.kotlin.payload.data
import kotlinx.coroutines.flow.*

@OptIn(ExperimentalMetadataApi::class)
class ConversationSocket(
    rsocketUrl: String,
    authRepo: AuthRepo,
) : BaseSocket(rsocketUrl, authRepo) {
    @NativeCoroutines
    fun streamConversations(): Flow<String> = flow {
        println("KMP: ConversationSocket.streamConversations")
        socketClient.rSocket(rsocketUrl)
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
