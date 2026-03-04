-- ============================================
-- Schema: Banco de Questões para Simulados
-- Projeto: Pedroaios (Coelho & Dias Cursos)
-- ============================================

-- 1. Disciplinas (ex: Direito Constitucional, Processo Penal)
CREATE TABLE disciplines (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL UNIQUE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- 2. Temas/Assuntos dentro de cada disciplina
CREATE TABLE topics (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  discipline_id UUID NOT NULL REFERENCES disciplines(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE(discipline_id, name)
);

-- 3. Questões
CREATE TABLE questions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  topic_id UUID NOT NULL REFERENCES topics(id) ON DELETE CASCADE,
  question_number INT, -- número da questão no material original
  question_type TEXT NOT NULL CHECK (question_type IN ('multiple_choice', 'true_false')),
  statement TEXT NOT NULL, -- enunciado completo da questão
  correct_answer TEXT NOT NULL, -- 'A','B','C','D','E' ou 'C','E' (certo/errado)
  detailed_explanation TEXT, -- explicação detalhada do gabarito
  difficulty TEXT CHECK (difficulty IN ('easy', 'medium', 'hard')),
  source TEXT, -- banca/origem (ex: CESPE, FCC, autoral)
  year INT, -- ano da prova original (se aplicável)
  target_exam TEXT, -- cargo/concurso alvo (ex: Delegado PCDF)
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- 4. Alternativas de cada questão
CREATE TABLE alternatives (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  question_id UUID NOT NULL REFERENCES questions(id) ON DELETE CASCADE,
  letter TEXT NOT NULL, -- 'A','B','C','D','E'
  text TEXT NOT NULL, -- texto da alternativa
  analysis TEXT, -- análise explicando por que está certa/errada
  is_correct BOOLEAN NOT NULL DEFAULT false,
  UNIQUE(question_id, letter)
);

-- 5. Simulados (agrupamento de questões)
CREATE TABLE simulados (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  title TEXT NOT NULL,
  description TEXT,
  total_time_minutes INT, -- tempo total para resolver
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- 6. Questões de cada simulado (N:N)
CREATE TABLE simulado_questions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  simulado_id UUID NOT NULL REFERENCES simulados(id) ON DELETE CASCADE,
  question_id UUID NOT NULL REFERENCES questions(id) ON DELETE CASCADE,
  position INT NOT NULL, -- ordem da questão no simulado
  UNIQUE(simulado_id, question_id),
  UNIQUE(simulado_id, position)
);

-- Índices para performance
CREATE INDEX idx_topics_discipline ON topics(discipline_id);
CREATE INDEX idx_questions_topic ON questions(topic_id);
CREATE INDEX idx_questions_type ON questions(question_type);
CREATE INDEX idx_alternatives_question ON alternatives(question_id);
CREATE INDEX idx_simulado_questions_simulado ON simulado_questions(simulado_id);
CREATE INDEX idx_simulado_questions_question ON simulado_questions(question_id);

-- Trigger para atualizar updated_at
CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER questions_updated_at
  BEFORE UPDATE ON questions
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();
