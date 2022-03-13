# Sterownie liniowe obiekte strukturalnie niestabilnym

1. Treść zadania projektowego 
2. Wprowadzenie modeli transmitancyjnych oraz modelu w przestrzeni stanu dla układu otwartego 
3. Charakterystyki układu otwartego (skokowa, impulsowa, Bode'go, Nyquist'a, mapa biegunów i zer) 
4. Synteza regulatora PID 
5. Synteza korektora przyspieszająco-opóźniającego fazę 
6. Synteza regulatora LQR 
7. Porównanie wyników dotyczących jakości sterowania dla opracowanych trzech metod sterowania 
8. Obserwacje i wnioski
9. Skrypty w środowisku Matlab

Wnioski:

Moim zadaniem było zaprojektowanie układu sterowania liniowego obiektem strukturalnie niestabilnym. Z pewnością czasochłonne byłoby wyprowadzenie modeli  transmisyjnych oraz modelu w przestrzeni stanu dla układu otwartego. Skorzystałem tutaj z wyprowadzonych już zależności.  W projekcie zastosowałem 3 typy regulatorów. Regulator PID był mi już znany wcześniej. Ponadto poznałem dwa nowe sposoby regulacji: kompensator lead-lag i regulator liniowo-kwadratowy (LQR). Z wykresu wynika, że układ otwarty jest niestabilny, ponieważ jego bieguny i zera znajdują się na dodatniej osi liczb rzeczywistych. Natomiast każdy z trzech sposobów regulacji stabilizuje układ. Dzięki pracy nad projektem mogłem sprawdzić jak zmiana poszczególnych parametrów regulacji wpłynęła  na zachowanie się układu zamkniętego. W regulatorze PID można zaobserwować, iż wzmocnienie ma duży wpływ na amplitudę wychyleń wahadła. Im większa wartość Kp, tym wychylenia wahadła były mniejsze, lecz gdy wartość była zbyt duża to otrzymywaliśmy na wykresach duże oscylację. Dzięki parametrowi Ki otrzymywaliśmy układ szybciej się stabilizował, gdyż został zmniejszony uchyb statyczny. Jednak zbyt duża wartość Ki powodowała oscylacje i przeregulowanie. Człon Kd zmniejsza przeregulowanie oraz przyszły uchyb. Dzięki zamodelowaniu układu w środowisku Simulink, mogłem wyprowadzić wartości wychylenia i przemieszczenia do Matlaba i zestawić kilka przebiegów na jednym wykresie. W regulatorze LQR przy zmianie wartości w macierzy Q przemieszczenie dla położenia wózka znacznie maleje, czyli wykres szybciej dąży do ustalenia się oraz dla wychylenia wahadła malało przeregulowanie oraz zmniejszał się czas ustalania tego wahadła. Aby spełnić założenia projektu musiałem użyć parametrów o dosyć wysokich wartościach. W rzeczywistości mógłby wystąpić problem z zastosowaniem takich nastaw. 
