abstract class Mapper<E, M> {
  E modelToEntity(M model);
  M entityToModel(E entity);
}
