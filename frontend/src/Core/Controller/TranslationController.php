<?php

declare(strict_types=1);

namespace App\Core\Controller;

use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Contracts\Translation\TranslatorInterface;
use Symfony\Component\Routing\Annotation\Route;

class TranslationController extends AbstractController
{
    #[Route('/i18n/{_locale}.json', name: 'i18n_catalog', requirements: ['_locale' => 'en|de'])]
    public function __invoke(TranslatorInterface $translator, string $_locale): JsonResponse
    {
        $catalogues = [];
        $catalogue = $translator->getCatalogue($_locale);
        foreach ($catalogue->getDomains() as $domain) {
            foreach ($catalogue->all($domain) as $key => $message) {
                $catalogues[$domain . '.' . $key] = $message;
            }
        }

        return new JsonResponse($catalogues);
    }
}
