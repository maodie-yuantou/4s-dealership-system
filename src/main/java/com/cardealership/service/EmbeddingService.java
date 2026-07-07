package com.cardealership.service;

import dev.langchain4j.model.embedding.onnx.allminilml6v2.AllMiniLmL6V2EmbeddingModel;
import dev.langchain4j.data.embedding.Embedding;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class EmbeddingService {
    private final AllMiniLmL6V2EmbeddingModel model;

    public EmbeddingService() {
        this.model = new AllMiniLmL6V2EmbeddingModel();
    }

    public float[] embed(String text) {
        Embedding embedding = model.embed(text).content();
        List<Float> floatList = embedding.vectorAsList();
        float[] result = new float[floatList.size()];
        for (int i = 0; i < floatList.size(); i++) result[i] = floatList.get(i);
        return result;
    }
}
