# Correction

## Question 4

Builder les 3 images demandées à l'aide des commandes suivantes :
```bash
cd dockerfile
docker build -t tacos:v1 --build-arg MENU_TYPE=tacos .
docker build -t burger:v1 --build-arg MENU_TYPE=burger .
docker build -t pizza:v1 --build-arg MENU_TYPE=pizza .
```

## Question 5

```bash
kind load docker-image tacos:v1 burger:v1 pizza:v1

kubectl apply -f burger.yaml -f ingress.yaml -f pizza.yaml -f taco.yaml
```