package com.noljanolja.shared

interface AuthRepo {
    suspend fun getAuthToken(): String?
}