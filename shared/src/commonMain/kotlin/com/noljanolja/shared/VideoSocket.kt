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

@OptIn(ExperimentalMetadataApi::class)
class VideoSocket(
    rsocketUrl: String,
    authRepo: AuthRepo,
) : BaseSocket(rsocketUrl, authRepo) {
    @NativeCoroutines
    suspend fun trackVideoProgress(data: String) {
        socketClient.rSocket(rsocketUrl)
            .fireAndForget(
                buildPayload {
                    data(data)
                    metadata(
                        CompositeMetadata(
                            RoutingMetadata("v1/videos"),
                            BearerAuthMetadata("Bearer ${authRepo.getAuthToken()}")
                        )
                    )
                }
            )
    }
}
