-- ============================================
-- Schema: Resultados e Respostas de Simulados
-- Projeto: Pedroaios (Coelho & Dias Cursos)
-- ============================================

-- 1. Adicionar colunas de lead na tabela existente
ALTER TABLE simulado_results ADD COLUMN IF NOT EXISTS participant_name TEXT;
ALTER TABLE simulado_results ADD COLUMN IF NOT EXISTS participant_email TEXT;

-- 2. Respostas individuais por questao (com tempo)
CREATE TABLE IF NOT EXISTS simulado_answers (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  result_id UUID NOT NULL REFERENCES simulado_results(id) ON DELETE CASCADE,
  question_id UUID NOT NULL,
  selected_answer TEXT NOT NULL,
  is_correct BOOLEAN NOT NULL,
  time_seconds INT NOT NULL DEFAULT 0,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Indices para performance
CREATE INDEX IF NOT EXISTS idx_simulado_results_email ON simulado_results(participant_email);
CREATE INDEX IF NOT EXISTS idx_simulado_answers_result ON simulado_answers(result_id);
CREATE INDEX IF NOT EXISTS idx_simulado_answers_question ON simulado_answers(question_id);

-- RLS para simulado_answers
ALTER TABLE simulado_answers ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Allow anonymous insert on simulado_answers"
  ON simulado_answers FOR INSERT
  TO anon WITH CHECK (true);

CREATE POLICY "Allow anonymous read on simulado_answers"
  ON simulado_answers FOR SELECT
  TO anon USING (true);
