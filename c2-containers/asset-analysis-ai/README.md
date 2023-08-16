# C2 - Asset Analysis AI

![](./asset-analysis-ai.svg)

## **Conteúdo do relatório**

```markdown
# Relatório do dia 14/08/2023

## Visão geral

|    IBOV    | SMALL  |   IFIX   |  S&P500  | Dow Jones | Dólar | Euro |
| :--------: | :----: | :------: | :------: | :-------: | :---: | :--: |
| 117.001,84 | 2.250 | 3.213,95 | 4.478,55 | 35.245,98 | 4,95  | 5,41 |

Gráfico de setor para representar os pesos ideais para cada ativo.

![Gráfico de setor](portifolio-composition.png)

Gráfico de dispersão para mostrar a relação risco e rentabilidade dos ativos da carteira.

![Gráfico de dispersão](risk-profitability.png)

## Análise de ativos

### VALE3

Gráfico de linha para mostrar o retorno acumulado do ativo VALE3 nos últimos 5 anos.

![Gráfico de linha](vale3.png)

- Preço atual: R$ 67,00
- Peso: 7.5%
- Preço teto: R$ 73,00
- Margem de segurança: 34%
- Risco (0 a 100): 40
- Recomendação: COMPRAR

### ITUB4

...

## Rentabilidade da carteira

Gráfico de linha para representar o retorno acumulado da carteira e comparar com o IBOV, CDI e IPCA.

![Gráfico de rentabilidade](profitability.png)
```

## Riskfolio Lib

### Otimização de carteiras

Para a otimização das carteiras de investimento, será utilizado:

- Logarithmic Mean Risk (Kelly Criterion) para investidores com perfil arrojado.

  Essa abordagem busca maximizar o crescimento do capital ao longo do tempo e é aplicável quando os investidores têm metas de longo prazo. No entanto, pode ser mais sensível a mudanças nas estimativas de retorno.

- Entropic Value at Risk (EVaR) para investidores com perfil conservador (**em análise**).

  O EVaR leva em consideração a assimetria nas distribuições de retorno. Ele pode ser adequado quando os investidores têm preocupações específicas com as caudas das distribuições e desejam controlar o risco em cenários de perda extrema.

## Modelo de ajuste de métricas

Esse modelo será uma rede neural Perceptron multicamada (_feed forward_) responsável por testar e disponibilizar o melhor conjunto de parâmetros que serão utilizados nas funções de otimização do Riskfolio Lib para a confeccionar do relatório personalizado do investidor. Além disso ele é responsável por selecionar o número ideal de ativos e seus pesos a fim de potencializar os ganhos, considerando a menor covariância possível entre esses ativos.

Abaixo está descrito o fluxo de desenvolvimento desse modelo:

1. **Preparação dos dados**:

   - Coleta dos dados financeiros do yFinance, como preços de ativos, retornos, indicadores fundamentalistas, etc.

   - Execução das funções do Riskfolio para obter as métricas de risco e retorno para diferentes combinações de ativos. Inicialmente será fornecido parâmetros aleatórios para o início do aprendizado da rede neural.

   - Organização desses dados de forma a fim de ter uma divisão clara entre os atributos previsores (entrada) e o atributo meta (alvo) para o treinamento da rede neural. As entradas incluem preços de ativos, retornos passados, métricas de risco, etc. Já o alvo é as métricas de otimização utilizados pelas funções do Riskfolio.

2. **Divisão dos dados**:

   - Separação dos dados em conjuntos de treinamento (75%) e teste (25%) para a avaliação de desempenho do modelo em dados não vistos durante o treinamento e evitar o _overfitting_.

3. **Arquitetura da rede neural**:

   - Perceptron multicamada (_feed forward_)

   - O número de camadas e neurônios em cada camada será definido por meio experimental.

   - Escolha das funções de ativação: (**em análise**)

     - Funções como ReLU (Rectified Linear Activation) e Sigmoide são as opções mais comuns para camadas intermediárias e que apresentam um desempenho bem satisfatório.

   - Escolha da função de perda e otimização:

     - Escolha uma função de perda para o cálculo do erro do modelo. (**em análise**)

     - Escolha de um otimizador para ajustar os pesos da rede durante o treinamento. (**em análise**)

4. **Treinamento e teste**:

   - Alimentação da rede neural com os dados de treinamento

   - Ajuste dos pesos para minimizar a função de perda.

   - Avaliação do desempenho do modelo usando os dados de teste com métricas de desempenho, precisão, acurácia, matriz de confusão e F1-Score.

   - Ajuste dos hiperparâmetros (como taxa de aprendizado) com base na estratégia de busca aleatória (_Random Search_) juntamente com a validação cruzada (_Cross-Validation_). (**em análise**)

     - Definição da faixa de hiperparâmetros: primeiramente, determinar um intervalo de valores possíveis para cada hiperparâmetro a ser ajustado (número de camadas ocultas, número de neurônios em cada camada, taxa de aprendizado).

     - Aplicação do Random Search: em cada iteração, selecionar aleatoriamente um conjunto de valores de hiperparâmetros dentro das faixas definidas.

     - Treinamento e validação cruzada: para cada conjunto de hiperparâmetros selecionado, executar a validação cruzada.

     - Avaliação do desempenho: avaliar o desempenho do modelo em cada iteração da busca aleatória usando as métricas de desempenho.

     - Seleção do melhor conjunto: ao final das iterações, escolher o conjunto de hiperparâmetros que resultou no melhor desempenho nas métricas avaliadas.

5. **Avaliação Final**:

   - Depois de obter um modelo treinado e testado, submetê-lo a uma nova base de dados para prever resultados.

   - Avaliação final do desempenho do modelo e realizar a comparação com as métricas de otimização esperadas. (**em análise**)

6. **Integração no sistema**
